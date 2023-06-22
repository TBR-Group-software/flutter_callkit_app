import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection/injection.dart';
import '../bloc/call/call_bloc.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final _callBlock = getIt.get<CallBloc>();

  void _leave() {
    _callBlock.add(LeaveCall());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallBloc, CallState>(
      bloc: _callBlock,
      listener: (context, state) {
        if (state is CallEnded) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Agora Video Call'),
          ),
          body: Stack(
            children: [
              if (state is CallActive) ...[
                Center(
                  child: _RemoteVideo(callActiveState: state),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 100,
                    height: 150,
                    child: Center(
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: state.rtcEngine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      ),
                    ),
                  ),
                ),
              ] else if (state is CallInitializeError)
                Center(child: Text(state.error.toString()))
              else
                const Center(child: CircularProgressIndicator()),
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
      },
    );
  }
}

class _RemoteVideo extends StatelessWidget {
  const _RemoteVideo({
    required CallActive callActiveState,
  }) : _callActiveState = callActiveState;

  final CallActive _callActiveState;

  @override
  Widget build(BuildContext context) {
    final channelId = _callActiveState.channelId;
    final remoteUsers = _callActiveState.remoteUsers;

    if (channelId != null && remoteUsers.isNotEmpty) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _callActiveState.rtcEngine,
          canvas: VideoCanvas(uid: remoteUsers.first),
          connection: RtcConnection(channelId: channelId),
        ),
      );
    }

    return const Text(
      'Please wait for remote user to join',
      textAlign: TextAlign.center,
    );
  }
}
