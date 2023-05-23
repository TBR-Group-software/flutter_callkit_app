import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalNotificationsGateWay {
  static final _oneSignal = OneSignal.shared;

  Future<void> registerUser(String userId) async {
    await _oneSignal.setAppId('');
    await _oneSignal.setExternalUserId(userId);
  }
}
