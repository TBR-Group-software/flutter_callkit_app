import 'package:flutter_voip_push_notification/flutter_voip_push_notification.dart';

class VoipTokenGateWay {
  final _voip = FlutterVoipPushNotification();

  Future<String?> getVoipToken() => _voip.getToken();
}
