import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../data/gate_ways/call_kit/ios_call_kit_gate_way.dart';
import '../../data/gate_ways/notifications/one_signal_voip_notifications_gate_way.dart';
import '../../data/gate_ways/user/user_gate_way.dart';
import '../../data/gate_ways/voip_token_gate_way.dart';
import '../../data/models/call_data.dart';
import '../../injection/injection.dart';
import 'call_kit_service.dart';

@LazySingleton(as: CallKitService, env: [CallEnvironment.ios])
class IosCallKitService implements CallKitService {
  IosCallKitService(
    this._userGateWay,
    this._voipTokenGateWay,
    this._oneSignalVoipNotificationsGateWay,
    this._iosCallKitGateWay,
  );

  final UserGateWay _userGateWay;
  final VoipTokenGateWay _voipTokenGateWay;
  final OneSignalVoipNotificationsGateWay _oneSignalVoipNotificationsGateWay;
  final IosCallKitGateWay _iosCallKitGateWay;

  /// Return [bool] value. True means that all required steps to configure VoIP
  /// services were done. False that one of the following issues has appeared:
  /// - there is no singed in user
  /// - something went wrong while getting the VoIP token.
  @override
  Future<bool> initTelecomServices() async {
    final user = await _userGateWay.getCurrentUser();
    if (user == null) return false;

    final voipToken = await _voipTokenGateWay.getVoipToken();
    if (voipToken == null || voipToken.isEmpty) return false;

    await _oneSignalVoipNotificationsGateWay.registerVoipToken(
      voipToken,
      user.id,
    );

    return true;
  }

  /// Always returns null. All call data is passed to [acceptedCallsStream].
  @override
  Future<CallData?> launchCallData() async {
    await _iosCallKitGateWay.configure();
    return null;
  }

  @override
  Stream<CallData> get acceptedCallsStream =>
      _iosCallKitGateWay.acceptedCallsStream;
}
