import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import '../../data/gate_ways/call_kit/android_call_kit_gate_way.dart';
import '../../data/gate_ways/notifications/one_signal_notifications_gate_way.dart';
import '../../data/gate_ways/user/firebase_user_gate_way.dart';
import '../../data/models/call_data.dart';
import 'call_kit_service.dart';

class AndroidCallKitService implements CallKitService {
  final _userGateWay = FirebaseUserGateWay();
  final _oneSignalNotificationsGateWay = OneSignalNotificationsGateWay();
  final _androidCallKit = AndroidCallKitGateWay();

  /// Return [bool] value. True means that all required steps to configure
  /// telecom services were done. False means that one of the following issues
  /// has appeared:
  /// - there is no singed in user
  /// - the user rejected to provide notification permission
  /// - the user rejected to provide phone permission.
  @override
  Future<bool> initTelecomServices() async {
    final user = await _userGateWay.getCurrentUser();
    if (user == null) return false;

    await _oneSignalNotificationsGateWay.registerUser(user.id);

    final notificationPermission = await Permission.notification.request();
    if (!notificationPermission.isGranted) return false;

    final phonePermission = await Permission.phone.request();
    if (!phonePermission.isGranted) return false;

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

  /// Returns [CallData] if app was launched from killed mode with phone call.
  @override
  Future<CallData?> launchCallData() => _androidCallKit.launchCallData();

  @override
  Stream<CallData> get acceptedCallsStream =>
      _androidCallKit.acceptedCallsStream;
}
