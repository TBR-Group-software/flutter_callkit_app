import 'package:permission_handler/permission_handler.dart';

import '../../data/gate_ways/calls/firebase_call_gate_way.dart';
import '../../data/gate_ways/user/firebase_user_gate_way.dart';
import '../../data/gate_ways/video_call/video_call_gate_way.dart';
import '../../data/models/call_engine.dart';
import 'call_service.dart';

class CallerCallService extends CallService {
  CallerCallService(super.videoCallGateWay)
      : _videoCallGateWay = videoCallGateWay;

  final VideoCallGateWay _videoCallGateWay;

  final _userGateWay = FirebaseUserGateWay();
  final _callGateWay = FirebaseCallGateWay();

  /// Initiates the call with another user. Accepts [calleePhoneNumber] and if
  /// this phone was found then call notification will be send to this user.
  /// Returns [CallEngine] if permissions were granted and call notification was
  /// send successfully. Returns null if one of the following issues has
  /// appeared:
  /// - wrong format of [calleePhoneNumber]
  /// - there is no singed in user
  /// - there is no user with such [calleePhoneNumber]
  /// - the user rejected to provide microphone permission
  /// - the user rejected to provide camera permission.
  Future<CallEngine?> initiateCall({
    required String calleePhoneNumber,
  }) async {
    final phone = _parsePhoneNumber(calleePhoneNumber);
    if (phone == null) return null;

    final phoneString = '+$phone';

    final user = await _userGateWay.getCurrentUser();
    if (user == null) return null;

    final callee = await _userGateWay.findUserByPhoneNumber(phoneString);
    if (callee == null) return null;

    final microphonePermission = await Permission.microphone.request();
    if (!microphonePermission.isGranted) return null;

    final cameraPermission = await Permission.camera.request();
    if (!cameraPermission.isGranted) return null;

    final channelData = await _callGateWay.initiateCall(callee.id);

    final engine = await _videoCallGateWay.joinChanel(
      channelId: channelData.channelId,
      token: channelData.token,
      userId: user.id,
    );

    return engine;
  }

  /// Converts the phone number from +380990887766 string to 380990887766
  /// integer.
  int? _parsePhoneNumber(String phoneNumber) {
    final phoneNumberWithoutCharacters =
        phoneNumber.replaceAll(RegExp('[^0-9]'), '');
    final phone = int.tryParse(phoneNumberWithoutCharacters);
    return phone;
  }
}
