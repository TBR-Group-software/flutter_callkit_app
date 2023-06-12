import 'dart:io';

import 'package:flutter/material.dart';

import 'injection/injection.dart';
import 'ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    configureDependencies(CallEnvironment.android);
  } else if (Platform.isIOS) {
    configureDependencies(CallEnvironment.ios);
  }

  runApp(const App());
}
