import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import '../data/android_call_kit_gate_way.dart';
import '../data/models/call_data.dart';

class AndroidCallKitService {
  final _androidCallKit = AndroidCallKitGateWay();

  /// Return [bool] value. True means that all required steps to configure
  /// telecom services were done. False means that the user rejected to provide
  /// phone permission.
  Future<bool> initTelecomServices() async {
    final result = await Permission.phone.request();
    if (!result.isGranted) return false;

    final hasPhoneAccount = await _androidCallKit.hasPhoneAccount();
    if (hasPhoneAccount ?? false) {
      return true;
    }

    final createdPhoneAccountEnabled =
        await _androidCallKit.createPhoneAccount();
    if (createdPhoneAccountEnabled ?? false) {
      return true;
    }

    await _androidCallKit.openPhoneAccounts();

    return true;
  }

  Future<CallData?> launchCallData() => _androidCallKit.launchCallData();

  StreamSubscription<CallData> listenAcceptedCalls(
    void Function(CallData callData) onData, {
    void Function(Object e, StackTrace s)? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _androidCallKit.listenAcceptedCalls(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
