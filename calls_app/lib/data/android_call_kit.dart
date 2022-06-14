import 'package:flutter/services.dart';

class AndroidCallKitGateWay {
  final _callKitChannel =
      const MethodChannel('in_app_calls_demo/flutter_call_kit/methods');

  Future<bool?> hasPhoneAccount() async {
    return await _callKitChannel
        .invokeMethod<bool>('hasPhoneAccount', <String, dynamic>{});
  }

  Future<bool?> openPhoneAccounts() async {
    return await _callKitChannel
        .invokeMethod<bool>('openPhoneAccounts', <String, dynamic>{});
  }
}
