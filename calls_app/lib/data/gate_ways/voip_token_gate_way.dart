import 'package:flutter_voip_push_notification/flutter_voip_push_notification.dart';
import 'package:injectable/injectable.dart';

@singleton
class VoipTokenGateWay {
  final _voip = FlutterVoipPushNotification();

  Future<String?> getVoipToken() => _voip.getToken();
}
