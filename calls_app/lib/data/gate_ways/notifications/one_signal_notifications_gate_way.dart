import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../environment_config.dart';

class OneSignalNotificationsGateWay {
  static final _oneSignal = OneSignal.shared;

  Future<void> registerUser(String userId) async {
    await _oneSignal.setAppId(EnvironmentConfig.oneSignalKey);
    await _oneSignal.setExternalUserId(userId);
  }
}
