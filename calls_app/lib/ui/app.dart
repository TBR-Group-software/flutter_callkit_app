import 'package:flutter/material.dart';

import 'pages/phone_authentication_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TBR In App Calls Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PhoneAuthenticationPage(),
    );
  }
}
