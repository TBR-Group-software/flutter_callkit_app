import '../../data/gate_ways/video_call/video_call_gate_way.dart';

class CallService {
  CallService(this._videoCallGateWay);

  final VideoCallGateWay _videoCallGateWay;

  Future<void> leaveCall() async {
    await _videoCallGateWay.leaveChanel();
  }

  Future<void> changeMicrophoneMode({required bool mute}) async {
    await _videoCallGateWay.changeMicrophoneMode(mute: mute);
  }

  Future<void> switchCamera() async {
    await _videoCallGateWay.switchCamera();
  }

  Future<void> changeVideoMode({required bool disable}) async {
    await _videoCallGateWay.changeVideoMode(disable: disable);
  }
}
