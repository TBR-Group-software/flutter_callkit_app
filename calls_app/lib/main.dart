import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

const _channel = MethodChannel('in_app_calls_demo/flutter_call_kit/methods');
const hasPhoneAccountMethod = 'hasPhoneAccount';
const createPhoneAccountMethod = 'createPhoneAccount';
const openPhoneAccountsMethod = 'openPhoneAccounts';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    try {
      await OneSignal.shared.setAppId('');
      await OneSignal.shared.promptUserForPushNotificationPermission();
      final result = await Permission.phone.request();
      if (result.isGranted) {
        await _initTelecomServices();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _initTelecomServices() async {
    final hasPhoneAccount = await _channel.invokeMethod<bool>(hasPhoneAccountMethod);
    if (hasPhoneAccount ?? false) {
      return;
    }

    final createdPhoneAccountEnabled = await _channel.invokeMethod<bool>(createPhoneAccountMethod);
    if (createdPhoneAccountEnabled ?? false) {
      return;
    }

    await _channel.invokeMethod<bool>(openPhoneAccountsMethod);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'One Signal setup',
            ),
            SizedBox(
              height: 10,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
