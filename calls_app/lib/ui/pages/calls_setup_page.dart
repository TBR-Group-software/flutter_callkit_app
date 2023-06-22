import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection/injection.dart';
import '../bloc/call/call_bloc.dart';
import '../bloc/call_kit/call_kit_cubit.dart';
import 'video_call_page.dart';

class CallsSetupPage extends StatefulWidget {
  const CallsSetupPage({super.key});

  @override
  State<CallsSetupPage> createState() => _CallsSetupPageState();
}

class _CallsSetupPageState extends State<CallsSetupPage> {
  final _callKitCubit = getIt.get<CallKitCubit>();
  final _callBlock = getIt.get<CallBloc>();

  final _phoneController = TextEditingController();

  Future<void> _call() async {
    _callBlock.add(InitiateCall(_phoneController.text));
  }

  void _openVideoCallPage() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<VideoCallPage>(
        builder: (_) => const VideoCallPage(),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallBloc, CallState>(
      bloc: _callBlock,
      listenWhen: (previous, current) {
        if (previous.runtimeType != current.runtimeType) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CallActive) {
          _openVideoCallPage();
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<CallKitCubit, CallKitState>(
                bloc: _callKitCubit,
                builder: (context, state) {
                  if (state is CallKitInitialized) {
                    return const Text('Calls setup complete');
                  } else if (state is CallKitNotInitialized) {
                    return const Text('Calls setup failed');
                  } else if (state is CallKitError) {
                    return Text('Calls setup error - ${state.error}');
                  }
                  return const Column(
                    children: <Widget>[
                      Text('Calls setup'),
                      SizedBox(height: 10),
                      CircularProgressIndicator(),
                    ],
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                    ),
                  ),
                  TextButton(
                    onPressed: _call,
                    child: const Text('Call'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
