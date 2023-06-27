part of 'call_bloc.dart';

@immutable
abstract class CallState {}

/// Indicates that there is no call currently.
class CallInitial extends CallState {}

/// Indicates that the error occurred during call initialization. It extends
/// from [CallInitial], so you can try to initialize call again.
class CallInitializeError extends CallInitial {
  CallInitializeError(this.error);

  final Object error;
}

/// Indicates that the call is initializing now. You can't initialize another
/// call when current is initializing.
class CallInitializing extends CallState {}

/// Indicates that the user is in a call now. You can initialize another call
/// only after current call is ended.
class CallActive extends CallState {
  CallActive(
    this._callService,
    this._engine, {
    required this.remoteUsers,
    this.channelId,
    this.interlocutorName,
  });

  final CallService _callService;
  final CallEngine _engine;

  final List<int> remoteUsers;

  /// Contains the channelId of the call. Will be set only after user
  /// successfully joins the channel.
  final String? channelId;

  /// The name of your caller or callee.
  final String? interlocutorName;

  RtcEngine get rtcEngine => _engine.rtcEngine;

  CallActive copyWith({
    List<int>? remoteUsers,
    String? channelId,
  }) {
    return CallActive(
      _callService,
      _engine,
      remoteUsers: remoteUsers ?? this.remoteUsers,
      channelId: channelId ?? this.channelId,
      interlocutorName: interlocutorName,
    );
  }
}

/// Indicates that the call was ended.
class CallEnded extends CallState {}
