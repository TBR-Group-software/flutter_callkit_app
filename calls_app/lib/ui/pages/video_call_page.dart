import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../injection/injection.dart';
import '../bloc/call/call_bloc.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final _callBlock = getIt.get<CallBloc>();

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
          body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.background.provider(),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                if (state is CallActive) ...[
                  _RemoteVideo(callActiveState: state),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _AppBar(callActiveState: state),
                          _BottomControllers(),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
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

    return Center(
      child: Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  _AppBar({
    required CallActive callActiveState,
  }) : _callActiveState = callActiveState;

  final _callBlock = getIt.get<CallBloc>();

  final CallActive _callActiveState;

  void _changeCamera() {
    _callBlock.add(SwitchCamera());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 26, top: 2, right: 8),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: _changeCamera,
              child: Assets.icons.loop.svg(),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const SizedBox(height: 2),
              Text(
                'Video Call',
                style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                    ),
              ),
              const SizedBox(height: 6),
              _Timer(),
            ],
          ),
        ),

        // Local video
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                height: 128,
                width: 83,
                child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _callActiveState.rtcEngine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Timer extends StatefulWidget {
  @override
  State<_Timer> createState() => _TimerState();
}

class _TimerState extends State<_Timer> {
  var _seconds = 0;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          setState(() => _seconds = timer.tick);
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: _seconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return Text(
      '${minutes.toString().padLeft(2, '0')}'
      ':'
      '${seconds.toString().padLeft(2, '0')}',
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}

class _BottomControllers extends StatefulWidget {
  @override
  State<_BottomControllers> createState() => _BottomControllersState();
}

class _BottomControllersState extends State<_BottomControllers> {
  final _callBlock = getIt.get<CallBloc>();

  var _isMicrophoneDisabled = false;
  var _isVideoDisabled = false;

  void _changeMicrophoneMode() {
    _callBlock.add(ChangeMicrophoneMode(mute: !_isMicrophoneDisabled));
    setState(() => _isMicrophoneDisabled = !_isMicrophoneDisabled);
  }

  void _endCall() {
    _callBlock.add(LeaveCall());
  }

  void _changeVideoMode() {
    _callBlock.add(ChangeVideoMode(disable: !_isVideoDisabled));
    setState(() => _isVideoDisabled = !_isVideoDisabled);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _changeMicrophoneMode,
          child: _isMicrophoneDisabled
              ? Assets.icons.mute.svg()
              : Assets.icons.speaker.svg(),
        ),
        const SizedBox(width: 14),
        GestureDetector(
          onTap: _endCall,
          child: Assets.icons.decline.svg(),
        ),
        const SizedBox(width: 14),
        GestureDetector(
          onTap: _changeVideoMode,
          child: _isVideoDisabled
              ? Assets.icons.videoOff.svg()
              : Assets.icons.videoOn.svg(),
        ),
      ],
    );
  }
}
