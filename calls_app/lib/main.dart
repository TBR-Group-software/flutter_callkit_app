import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'data/models/call_data.dart';
import 'domain/android_call_kit_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _initCompleter = Completer<bool>();
  final _launchCallDataCompleter = Completer<CallData?>();

  CallData? _callData;
  Object? _callDataError;

  @override
  void initState() {
    super.initState();
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print(event.jsonRepresentation());
    });
    _initPhoneCalls();
  }

  Future<void> _initPhoneCalls() async {
    final callKit = AndroidCallKitService();

    try {
      await OneSignal.shared.setAppId('b716360f-9810-4790-8771-ba87c31578ae');
      await OneSignal.shared.promptUserForPushNotificationPermission();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
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
                    return const Text('Calls setup complete');
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
            ],
          ),
        ),
      ),
    );
  }
}
