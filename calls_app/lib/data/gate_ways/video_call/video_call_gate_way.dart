import '../../models/call_engine.dart';

abstract class VideoCallGateWay {
  Future<CallEngine> joinChanel({
    required String channelId,
    required String token,
    required String userId,
  });

  Future<void> leaveChanel();

  Future<void> changeMicrophoneMode({required bool mute});

  Future<void> switchCamera();

  Future<void> changeVideoMode({required bool disable});
}
