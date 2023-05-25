import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/gate_ways/firebase/firebase_initializer_gate_way.dart';
import '../../data/gate_ways/user/firebase_user_gate_way.dart';
import '../../data/models/call_data.dart';
import '../../domain/call_kit_service/android_call_kit_service.dart';
import '../../domain/call_kit_service/ios_call_kit_service.dart';

class CallsSetupPage extends StatefulWidget {
  const CallsSetupPage({Key? key}) : super(key: key);

  @override
  State<CallsSetupPage> createState() => _CallsSetupPageState();
}

class _CallsSetupPageState extends State<CallsSetupPage> {
  final _initCompleter = Completer<bool>();
  final _launchCallDataCompleter = Completer<CallData?>();

  CallData? _callData;
  Object? _callDataError;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _initAndroidPhoneCalls();
    } else if (Platform.isIOS) {
      _initIOSPhoneCalls();
    }
  }

  Future<void> _initAndroidPhoneCalls() async {
    final callKit = AndroidCallKitService();

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

    callKit.listenAcceptedCalls(
      (callData) {
        if (!mounted) {
          _callData = callData;
          return;
        }

        setState(() => _callData = callData);
      },
      onError: (Object e, _) {
        if (!mounted) {
          _callDataError = e;
          return;
        }

        setState(() => _callDataError = e);
      },
    );
  }

  Future<void> _initIOSPhoneCalls() async {
    final callKit = IosCallKitService();

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

    callKit.listenAcceptedCalls(
      (callData) {
        if (!mounted) {
          _callData = callData;
          return;
        }

        setState(() => _callData = callData);
      },
      onError: (Object e, _) {
        if (!mounted) {
          _callDataError = e;
          return;
        }

        setState(() => _callDataError = e);
      },
    );
  }

  Future<void> _call() async {
    final functions = await FirebaseInitializerGateWay.instance.functions;

    final userGateWay = FirebaseUserGateWay();
    final user = await userGateWay.getCurrentUser();
    if (user == null) return;

    try {
      await functions.httpsCallable('sendCallNotification').call<void>(
        <String, dynamic>{
          'calleeId': user.id,
        },
      );
    } catch (e) {
      log(e.toString());
    }
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
                return Column(
                  children: const <Widget>[
                    Text('Calls setup'),
                    SizedBox(height: 10),
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
            TextButton(
              onPressed: _call,
              child: const Text('Call'),
            ),
          ],
        ),
      ),
    );
  }
}
