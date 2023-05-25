import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializerGateWay {
  FirebaseInitializerGateWay._();

  static final _instance = FirebaseInitializerGateWay._();

  final _firebaseCompleter = Completer<FirebaseApp>();

  Future<void> init() async {
    try {
      final app = await Firebase.initializeApp();
      _firebaseCompleter.complete(app);
    } catch (e, s) {
      _firebaseCompleter.completeError(e, s);
    }
  }

  static FirebaseInitializerGateWay get instance => _instance;

  Future<FirebaseAuth> get firebaseAuth async {
    await _firebaseCompleter.future;
    return FirebaseAuth.instance;
  }

  Future<FirebaseFirestore> get firestore async {
    await _firebaseCompleter.future;
    return FirebaseFirestore.instance;
  }

  Future<FirebaseFunctions> get functions async {
    await _firebaseCompleter.future;
    return FirebaseFunctions.instance;
  }
}
