import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/call_kit/call_kit_service.dart';
import '../../controllers/call_controller.dart';
import '../../controllers/call_data_error_controller.dart';

part 'call_kit_state.dart';

@lazySingleton
class CallKitCubit extends Cubit<CallKitState> {
  CallKitCubit(
    this._callController,
    this._callDataErrorController,
    this._callKitService,
  ) : super(CallKitInitial()) {
    _initCallListeners();
    initTelecomServices();
  }

  final CallController _callController;
  final CallDataErrorController _callDataErrorController;
  final CallKitService _callKitService;

  Future<void> _initCallListeners() async {
    _callKitService.acceptedCallsStream.listen(
      _callController.addCallData,
      onError: _callDataErrorController.addCallError,
    );

    try {
      final launchCallData = await _callKitService.launchCallData();
      if (launchCallData != null) {
        _callController.addCallData(launchCallData);
      }
    } catch (e) {
      _callDataErrorController.addCallError(e);
    }
  }

  Future<void> initTelecomServices() async {
    emit(CallKitLoading());
    try {
      final initialized = await _callKitService.initTelecomServices();
      if (initialized) {
        emit(CallKitInitialized());
      } else {
        emit(CallKitNotInitialized());
      }
    } catch (e) {
      emit(CallKitError(e));
    }
  }
}
