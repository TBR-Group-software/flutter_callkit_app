import '../data/gate_ways/notifications/one_signal_voip_notifications_gate_way.dart';
import '../data/gate_ways/voip_token_gate_way.dart';

class IosCallKitService {
  final _voipTokenGateWay = VoipTokenGateWay();
  final _oneSignalVoipNotificationsGateWay =
      OneSignalVoipNotificationsGateWay();

  /// Return [bool] value. True means that all required steps to configure
  /// VoIP services were done. False means something went wrong while getting
  /// the VoIP token.
  Future<bool> initTelecomServices() async {
    final voipToken = await _voipTokenGateWay.getVoipToken();
    if (voipToken == null || voipToken.isEmpty) return false;

    await _oneSignalVoipNotificationsGateWay.registerVoipToken(
      voipToken,
      '07acf653-5357-4ae1-997c-60c0f9a76dc7',
    );

    return true;
  }
}
