import 'package:flutter/material.dart';

import 'data/gate_ways/firebase/firebase_initializer_gate_way.dart';
import 'ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializerGateWay.instance.init();
  runApp(const App());
}
