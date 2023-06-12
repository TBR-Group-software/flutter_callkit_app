import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';
import 'package:injectable/injectable.dart';

import '../../models/call_data.dart';

@lazySingleton
class IosCallKitGateWay {
  IosCallKitGateWay() {
    _init();
  }

  static const _tag = 'IosCallKitGateWay';

  /// Calls channel
  static const _callDataChannel = MethodChannel('in_app_calls_demo/call_data');

  static const _getCallDataMethod = 'getCallData';

  final _provider = FCXProvider();
  final _callController = FCXCallController();

  final _acceptedCallsStream = StreamController<CallData>.broadcast();

  Stream<CallData> get acceptedCallsStream => _acceptedCallsStream.stream;

  void _init() {
    _provider.performAnswerCallAction = _answerCallAction;
  }

  Future<void> configure() async {
    await _callController.configure();
    await _provider.configure(
      FCXProviderConfiguration(
        'in_app_calls_demo',
        supportedHandleTypes: {FCXHandleType.Generic},
      ),
    );
  }

  Future<void> _answerCallAction(FCXAnswerCallAction answerCallAction) async {
    log('$_tag: handled FCXAnswerCallAction with id '
        '${answerCallAction.callUuid}');

    try {
      await answerCallAction.fulfill();
      final callData = await _getCallData(answerCallAction.callUuid);
      await _endCall(answerCallAction.callUuid);

      if (callData == null) return;

      _acceptedCallsStream.add(callData);
    } catch (e, s) {
      _acceptedCallsStream.addError(e, s);
    }
  }

  Future<CallData?> _getCallData(String callId) async {
    final callData = await _callDataChannel.invokeMethod<Map<dynamic, dynamic>>(
      _getCallDataMethod,
      {'callId': callId},
    );
    if (callData == null) return null;

    return CallData.fromMap(callData.cast<String, dynamic>());
  }

  Future<void> _endCall(String callId) async {
    await _callController
        .requestTransactionWithAction(FCXEndCallAction(callId));
  }
}
