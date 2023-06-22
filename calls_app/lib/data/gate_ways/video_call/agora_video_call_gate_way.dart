import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:injectable/injectable.dart';

import '../../../environment_config.dart';
import '../../models/call_engine.dart';
import '../../models/call_error.dart';
import 'video_call_gate_way.dart';

@Injectable(as: VideoCallGateWay)
class AgoraVideoCallGateWay implements VideoCallGateWay {
  AgoraVideoCallGateWay() {
    _init();
  }

  static const _tag = 'AgoraVideoCallGateWay';

  final _engineCompleter = Completer<CallEngine>();

  Future<void> _init() async {
    final rtcEngine = createAgoraRtcEngine();
    const appId = EnvironmentConfig.agoraRtcAppId;
    await rtcEngine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
    await rtcEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    const configuration = VideoEncoderConfiguration(
      dimensions: VideoDimensions(width: 1920, height: 1080),
    );
    await rtcEngine.setVideoEncoderConfiguration(configuration);

    final callEngine = CallEngine(rtcEngine);

    rtcEngine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (connection, userId, elapsed) {
          log('$_tag [onUserJoined] connection: ${connection.toJson()} '
              'remoteUid: $userId elapsed: $elapsed');
          callEngine.addRemoteUserJoinedEvent(userId);
        },
        onUserOffline: (connection, userId, reason) {
          log('$_tag [onUserOffline] connection: ${connection.toJson()} '
              'remoteUid: $userId reason: $reason');
          callEngine.addRemoteUserOfflineEvent(userId);
        },
        onJoinChannelSuccess: (connection, elapsed) {
          log('$_tag [onJoinChannelSuccess] connection: ${connection.toJson()} '
              'elapsed: $elapsed');
          callEngine.addUserJoinedEvent(connection.channelId);
        },
        onError: (error, message) {
          log('$_tag handled event [onError] error: $error, message: $message');
          final callError = CallError(code: error, message: message);
          callEngine.addErrorEvent(callError);
        },
      ),
    );

    _engineCompleter.complete(callEngine);
  }

  @override
  Future<CallEngine> joinChanel({
    required String channelId,
    required String token,
    required String userId,
  }) async {
    final callEngine = await _engineCompleter.future;
    final rtcEngine = callEngine.rtcEngine;

    await rtcEngine.joinChannelWithUserAccount(
      token: token,
      channelId: channelId,
      userAccount: userId,
      options: const ChannelMediaOptions(),
    );

    await rtcEngine.enableVideo();
    await rtcEngine.startPreview();

    return callEngine;
  }

  @override
  Future<void> leaveChanel() async {
    final callEngine = await _engineCompleter.future;
    final rtcEngine = callEngine.rtcEngine;

    await rtcEngine.stopPreview();
    await rtcEngine.leaveChannel();

    await callEngine.release();
  }

  @override
  Future<void> changeMicrophoneMode({required bool mute}) async {
    final callEngine = await _engineCompleter.future;
    final rtcEngine = callEngine.rtcEngine;

    await rtcEngine.muteLocalAudioStream(mute);
  }

  @override
  Future<void> switchCamera() async {
    final callEngine = await _engineCompleter.future;
    final rtcEngine = callEngine.rtcEngine;

    await rtcEngine.switchCamera();
  }

  @override
  Future<void> changeVideoMode({required bool disable}) async {
    final callEngine = await _engineCompleter.future;
    final rtcEngine = callEngine.rtcEngine;

    if (disable) {
      await rtcEngine.disableVideo();
    } else {
      await rtcEngine.enableVideo();
    }
  }
}
