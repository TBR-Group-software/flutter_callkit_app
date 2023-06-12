import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import '../../data/models/call_engine.dart';
import '../../domain/calls/call_service.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({
    required this.engine,
    required this.callService,
    super.key,
  });

  final CallEngine engine;
  final CallService callService;

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  Future<void> _leave() async {
    await widget.callService.leaveCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _RemoteVideo(engine: widget.engine),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: widget.engine.rtcEngine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: _leave,
              child: const Text('leave'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RemoteVideo extends StatelessWidget {
  const _RemoteVideo({
    required this.engine,
  });

  final CallEngine engine;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: engine.userJoinedStream.first,
      builder: (context, userJoinedSnapshot) {
        return StreamBuilder<int>(
          stream: engine.remoteUserJoinedStream,
          builder: (context, remoteUserJoinedSnapshot) {
            final channelId = userJoinedSnapshot.data;
            final remoteUserId = remoteUserJoinedSnapshot.data;

            if (channelId != null && remoteUserId != null) {
              return AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: engine.rtcEngine,
                  canvas: VideoCanvas(uid: remoteUserId),
                  connection: RtcConnection(channelId: channelId),
                ),
              );
            }

            return const Text(
              'Please wait for remote user to join',
              textAlign: TextAlign.center,
            );
          },
        );
      },
    );
  }
}
