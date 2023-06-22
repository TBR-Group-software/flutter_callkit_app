import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/call_data.dart';
import '../../../data/models/call_engine.dart';
import '../../../data/models/call_error.dart';
import '../../../domain/calls/call_service.dart';
import '../../../domain/calls/callee_call_service.dart';
import '../../../domain/calls/caller_call_service.dart';
import '../../../injection/injection.dart';
import '../../controllers/call_controller.dart';
import '../../controllers/call_error_controller.dart';

part 'call_event.dart';
part 'call_state.dart';

@lazySingleton
class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc(this._callController, this._callErrorController)
      : super(CallInitial()) {
    on<InitiateCall>(_onInitiateCallEvent, transformer: sequential());
    on<JoinCall>(_onJoinCallEvent, transformer: sequential());
    on<_AddRemoteUser>(_onAddRemoteUserEvent);
    on<_RemoveRemoteUser>(_onRemoveRemoteUserEvent);
    on<_JoinChannel>(_onJoinChannelEvent);
    on<LeaveCall>(_onLeaveCallEvent);
    on<ChangeMicrophoneMode>(_onChangeMicrophoneModeEvent);
    on<SwitchCamera>(_onSwitchCameraEvent);
    on<ChangeVideoMode>(_onChangeVideoModeEvent);
    _callDataSubscription =
        _callController.callDataStream.listen(_callControllerListener);
  }

  final CallController _callController;
  late final StreamSubscription<CallData> _callDataSubscription;

  final CallErrorController _callErrorController;

  StreamSubscription<int>? _remoteUserJoinedSubscription;
  StreamSubscription<int>? _remoteUserOfflineSubscription;
  StreamSubscription<String?>? _userJoinedSubscription;
  StreamSubscription<CallError>? _errorSubscription;

  void _callControllerListener(CallData callData) {
    add(JoinCall(callData));
  }

  @override
  Future<void> close() async {
    await _callDataSubscription.cancel();
    return super.close();
  }

  /// Initiates a call as a caller.
  Future<void> _onInitiateCallEvent(
    InitiateCall event,
    Emitter<CallState> emit,
  ) async {
    if (state is! CallInitial) return;

    try {
      final callerCallService = getIt.get<CallerCallService>();
      final callEngine = await callerCallService.initiateCall(
        calleePhoneNumber: event.phoneNumber,
      );

      if (callEngine == null) {
        emit(CallInitializeError('Failed to initialize call'));
        return;
      }

      emit(
        CallActive(
          callerCallService,
          callEngine,
          remoteUsers: const [],
        ),
      );

      _subscribeOnCallEvents(callEngine);
    } catch (e) {
      emit(CallInitializeError(e));
    }
  }

  /// Joins a call as a callee.
  Future<void> _onJoinCallEvent(
    JoinCall event,
    Emitter<CallState> emit,
  ) async {
    if (state is! CallInitial) return;

    final channelId = event.callData.channelId;
    if (channelId == null) {
      emit(CallInitializeError('Channel id is null'));
      return;
    }

    try {
      final callerCallService = getIt.get<CalleeCallService>();
      final callEngine = await callerCallService.joinCall(
        channelId: channelId,
      );

      if (callEngine == null) {
        emit(CallInitializeError('Failed to initialize call'));
        return;
      }

      emit(
        CallActive(
          callerCallService,
          callEngine,
          remoteUsers: const [],
        ),
      );

      _subscribeOnCallEvents(callEngine);
    } catch (e) {
      emit(CallInitializeError(e));
    }
  }

  void _subscribeOnCallEvents(CallEngine engine) {
    _remoteUserJoinedSubscription = engine.remoteUserJoinedStream.listen((uid) {
      add(_AddRemoteUser(uid));
    });
    _remoteUserOfflineSubscription =
        engine.remoteUserOfflineStream.listen((uid) {
      add(_RemoveRemoteUser(uid));
    });
    _userJoinedSubscription = engine.userJoinedStream.listen((channelId) {
      add(_JoinChannel(channelId));
    });
    _errorSubscription =
        engine.errorStream.listen(_callErrorController.addCallError);
  }

  void _onAddRemoteUserEvent(
    _AddRemoteUser event,
    Emitter<CallState> emit,
  ) {
    final localState = state;
    if (localState is! CallActive) return;

    emit(
      localState.copyWith(
        remoteUsers: [event.uid, ...localState.remoteUsers],
      ),
    );
  }

  void _onRemoveRemoteUserEvent(
    _RemoveRemoteUser event,
    Emitter<CallState> emit,
  ) {
    final localState = state;
    if (localState is! CallActive) return;

    emit(
      localState.copyWith(
        remoteUsers: [...localState.remoteUsers]..remove(event.uid),
      ),
    );
  }

  void _onJoinChannelEvent(
    _JoinChannel event,
    Emitter<CallState> emit,
  ) {
    final localState = state;
    if (localState is! CallActive) return;

    emit(
      localState.copyWith(
        channelId: event.channelId,
      ),
    );
  }

  Future<void> _onLeaveCallEvent(
    LeaveCall event,
    Emitter<CallState> emit,
  ) async {
    final localState = state;
    if (localState is! CallActive) return;

    try {
      final remoteUserJoinedCancel = _remoteUserJoinedSubscription?.cancel();
      final remoteUserOfflineCancel = _remoteUserOfflineSubscription?.cancel();
      final userJoinedCancel = _userJoinedSubscription?.cancel();
      final errorCancel = _errorSubscription?.cancel();

      await Future.wait([
        if (remoteUserJoinedCancel != null) remoteUserJoinedCancel,
        if (remoteUserOfflineCancel != null) remoteUserOfflineCancel,
        if (userJoinedCancel != null) userJoinedCancel,
        if (errorCancel != null) errorCancel,
      ]);
      await localState._callService.leaveCall();
    } catch (e) {
      _callErrorController.addCallError(e);
    } finally {
      emit(CallEnded());
      emit(CallInitial());
    }
  }

  Future<void> _onChangeMicrophoneModeEvent(
    ChangeMicrophoneMode event,
    Emitter<CallState> emit,
  ) async {
    final localState = state;
    if (localState is! CallActive) return;

    try {
      await localState._callService.changeMicrophoneMode(mute: event.mute);
    } catch (e) {
      _callErrorController.addCallError(e);
    }
  }

  Future<void> _onSwitchCameraEvent(
    SwitchCamera event,
    Emitter<CallState> emit,
  ) async {
    final localState = state;
    if (localState is! CallActive) return;

    try {
      await localState._callService.switchCamera();
    } catch (e) {
      _callErrorController.addCallError(e);
    }
  }

  Future<void> _onChangeVideoModeEvent(
    ChangeVideoMode event,
    Emitter<CallState> emit,
  ) async {
    final localState = state;
    if (localState is! CallActive) return;

    try {
      await localState._callService.changeVideoMode(disable: event.disable);
    } catch (e) {
      _callErrorController.addCallError(e);
    }
  }
}
