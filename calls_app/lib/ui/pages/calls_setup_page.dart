import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../data/models/call_data.dart';
import '../../domain/call_kit_service/call_kit_service.dart';
import '../../domain/calls/callee_call_service.dart';
import '../../domain/calls/caller_call_service.dart';
import '../../injection/injection.dart';
import 'video_call_page.dart';

class CallsSetupPage extends StatefulWidget {
  const CallsSetupPage({super.key});

  @override
  State<CallsSetupPage> createState() => _CallsSetupPageState();
}

class _CallsSetupPageState extends State<CallsSetupPage> {
  final _initCompleter = Completer<bool>();
  final _launchCallDataCompleter = Completer<CallData?>();

  final _phoneController = TextEditingController();

  CallData? _callData;
  Object? _callDataError;

  @override
  void initState() {
    super.initState();
    _initPhoneCalls();
  }

  Future<void> _initPhoneCalls() async {
    final callKit = getIt.get<CallKitService>();

    try {
      final callsSetup = await callKit.initTelecomServices();
      _initCompleter.complete(callsSetup);
    } catch (e, s) {
      _initCompleter.completeError(e, s);
      return;
    }

    try {
      final launchCallData = await callKit.launchCallData();
      _launchCallDataCompleter.complete(launchCallData);
    } catch (e, s) {
      _launchCallDataCompleter.completeError(e, s);
    }

    callKit.acceptedCallsStream.listen(
      (callData) {
        if (!mounted) {
          _callData = callData;
          return;
        }

        setState(() => _callData = callData);
      },
      onError: (Object e) {
        if (!mounted) {
          _callDataError = e;
          return;
        }

        setState(() => _callDataError = e);
      },
    );
  }

  Future<void> _call() async {
    try {
      final callerCallService = getIt.get<CallerCallService>();
      final callEngine = await callerCallService.initiateCall(
        calleePhoneNumber: _phoneController.text,
      );

      if (callEngine == null) return;

      // ignore: use_build_context_synchronously, unawaited_futures
      Navigator.push<void>(
        context,
        MaterialPageRoute<VideoCallPage>(
          builder: (_) =>
              VideoCallPage(engine: callEngine, callService: callerCallService),
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _joinCall() async {
    final channelId = _callData?.channelId;
    if (channelId == null) return;

    try {
      final callerCallService = getIt.get<CalleeCallService>();
      final callEngine = await callerCallService.joinCall(
        channelId: channelId,
      );

      if (callEngine == null) return;

      // ignore: use_build_context_synchronously, unawaited_futures
      Navigator.push<void>(
        context,
        MaterialPageRoute<VideoCallPage>(
          builder: (_) =>
              VideoCallPage(engine: callEngine, callService: callerCallService),
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<CallData?>(
              future: _launchCallDataCompleter.future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Initial call data - ${snapshot.data!.callerName}',
                  );
                }
                if (snapshot.error != null) {
                  return Text('Initial call data error - ${snapshot.error}');
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 10),
            if (_callData != null) ...[
              Text('Call data - ${_callData!.callerName}'),
              const SizedBox(height: 10),
            ],
            if (_callDataError != null) ...[
              Text('Call data error - $_callDataError'),
              const SizedBox(height: 10),
            ],
            FutureBuilder<bool>(
              future: _initCompleter.future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!
                        ? 'Calls setup complete'
                        : 'Calls setup failed',
                  );
                }
                if (snapshot.error != null) {
                  return Text('Calls setup error - ${snapshot.error}');
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
            TextButton(
              onPressed: _joinCall,
              child: const Text('Join Call'),
            ),
          ],
        ),
      ),
    );
  }
}
