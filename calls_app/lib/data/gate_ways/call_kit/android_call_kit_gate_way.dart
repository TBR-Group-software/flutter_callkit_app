import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';

import '../../models/call_data.dart';

class AndroidCallKitGateWay {
  AndroidCallKitGateWay() {
    _init();
  }

  static const _tag = 'AndroidCallKitGateWay';

  /// Foreground calls channel
  static const _callForegroundChannel =
      MethodChannel('in_app_calls_demo/call/foreground');

  static const _callAnsweredMethod = 'callAnswered';

  /// Background calls channel
  static const _callBackgroundChannel =
      MethodChannel('in_app_calls_demo/call/background');

  static const _isAppLaunchedWithCallDataMethod = 'isAppLaunchedWithCallData';

  /// Call Kit channel for general calls setup
  static const _callKitChannel =
      MethodChannel('in_app_calls_demo/flutter_call_kit/methods');

  static const _hasPhoneAccountMethod = 'hasPhoneAccount';
  static const _createPhoneAccountMethod = 'createPhoneAccount';
  static const _openPhoneAccountsMethod = 'openPhoneAccounts';

  final _acceptedCallsStream = StreamController<CallData>.broadcast();

  void _init() {
    _callForegroundChannel.setMethodCallHandler(_callForegroundChannelHandler);
  }

  Future<void> _callForegroundChannelHandler(MethodCall call) async {
    log('$_tag: handled ${_callForegroundChannel.name} channel ${call.method} '
        'method');
    switch (call.method) {
      case _callAnsweredMethod:
        try {
          final callData = call.arguments as Map<dynamic, dynamic>;
          _acceptedCallsStream
              .add(CallData.fromMap(callData.cast<String, dynamic>()));
        } catch (e, s) {
          _acceptedCallsStream.addError(e, s);
        }
        break;
      default:
        throw UnimplementedError('${call.method} is not implemented for '
            '${_callForegroundChannel.name}');
    }
  }

  StreamSubscription<CallData> listenAcceptedCalls(
    void Function(CallData callData) onData, {
    void Function(Object e, StackTrace s)? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _acceptedCallsStream.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future<CallData?> launchCallData() async {
    final callData = await _callBackgroundChannel
        .invokeMethod<Map<dynamic, dynamic>>(_isAppLaunchedWithCallDataMethod);
    if (callData == null) return null;

    return CallData.fromMap(callData.cast<String, dynamic>());
  }

  Future<bool?> hasPhoneAccount() async {
    return _callKitChannel.invokeMethod<bool>(_hasPhoneAccountMethod);
  }

  Future<bool?> createPhoneAccount() async {
    return _callKitChannel.invokeMethod<bool>(_createPhoneAccountMethod);
  }

  Future<bool?> openPhoneAccounts() async {
    return _callKitChannel.invokeMethod<bool>(_openPhoneAccountsMethod);
  }
}
