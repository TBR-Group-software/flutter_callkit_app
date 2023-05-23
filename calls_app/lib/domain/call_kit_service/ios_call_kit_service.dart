import 'dart:async';

import '../../data/gate_ways/call_kit/ios_call_kit_gate_way.dart';
import '../../data/gate_ways/notifications/one_signal_voip_notifications_gate_way.dart';
import '../../data/gate_ways/voip_token_gate_way.dart';
import '../../data/models/call_data.dart';
import 'call_kit_service.dart';

class IosCallKitService implements CallKitService {
  final _voipTokenGateWay = VoipTokenGateWay();
  final _oneSignalVoipNotificationsGateWay =
      OneSignalVoipNotificationsGateWay();
  final _iosCallKitGateWay = IosCallKitGateWay();

  /// Return [bool] value. True means that all required steps to configure
  /// VoIP services were done. False means something went wrong while getting
  /// the VoIP token.
  @override
  Future<bool> initTelecomServices() async {
    final voipToken = await _voipTokenGateWay.getVoipToken();
    if (voipToken == null || voipToken.isEmpty) return false;

    await _oneSignalVoipNotificationsGateWay.registerVoipToken(
      voipToken,
      '07acf653-5357-4ae1-997c-60c0f9a76dc7',
    );

    return true;
  }

  /// Always returns null. All call data is passed to [listenAcceptedCalls]
  /// method.
  @override
  Future<CallData?> launchCallData() async {
    await _iosCallKitGateWay.configure();
    return null;
  }

  @override
  StreamSubscription<CallData> listenAcceptedCalls(
    void Function(CallData callData) onData, {
    void Function(Object e, StackTrace s)? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _iosCallKitGateWay.listenAcceptedCalls(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}