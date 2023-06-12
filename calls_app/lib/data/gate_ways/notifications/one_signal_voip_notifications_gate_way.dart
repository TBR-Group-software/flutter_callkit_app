import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../environment_config.dart';

@singleton
class OneSignalVoipNotificationsGateWay {
  final _dio = Dio(BaseOptions(baseUrl: 'https://onesignal.com/'));

  /// To receive VoIP notifications with OneSignal it is needed to POST
  /// [voipToken] to OneSignal API. See more details in OneSignal documentation:
  /// https://documentation.onesignal.com/docs/voip-notifications#3-add-the-device-with-a-voip-token
  Future<void> registerVoipToken(String voipToken, String userId) =>
      _dio.post<dynamic>(
        'api/v1/players',
        data: <String, dynamic>{
          'app_id': EnvironmentConfig.oneSignalVoipKey,
          'identifier': voipToken,
          'external_user_id': userId,
          'device_type': 0,
          if (kDebugMode) 'test_type': 1,
        },
      );
}
