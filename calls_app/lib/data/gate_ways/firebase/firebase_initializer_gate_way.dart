import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseInitializerGateWay {
  FirebaseInitializerGateWay() {
    _init();
  }

  final _firebaseCompleter = Completer<FirebaseApp>();

  Future<void> _init() async {
    try {
      final app = await Firebase.initializeApp();
      _firebaseCompleter.complete(app);
    } catch (e, s) {
      _firebaseCompleter.completeError(e, s);
    }
  }

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
