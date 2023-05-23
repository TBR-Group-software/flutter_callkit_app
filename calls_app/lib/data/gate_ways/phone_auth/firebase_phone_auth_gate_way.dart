import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../models/code_sent_data.dart';
import '../firebase/firebase_initializer_gate_way.dart';
import 'phone_auth_gate_way.dart';

class FirebasePhoneAuthGateWay implements PhoneAuthGateWay {
  final _firebaseInitializer = FirebaseInitializerGateWay.instance;

  @override
  Future<CodeSentData> verifyPhoneNumber(
    String phoneNumber, [
    int? resendingToken,
  ]) async {
    final completer = Completer<CodeSentData>();

    final firebaseAuth = await _firebaseInitializer.firebaseAuth;

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendingToken,
      verificationCompleted: (_) {
        // TODO(Nikita): this method call is unused.
      },
      verificationFailed: completer.completeError,
      codeSent: (String verificationId, int? resendToken) {
        final codeSentData = CodeSentData(
          verificationId: verificationId,
          resendToken: resendToken,
        );
        completer.complete(codeSentData);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (completer.isCompleted) return;
        final codeSentData = CodeSentData(verificationId: verificationId);
        completer.complete(codeSentData);
      },
    );

    return completer.future;
  }

  @override
  Future<void> signInWithCredentials(
    String verificationId,
    String smsCode,
  ) async {
    final authCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final firebaseAuth = await _firebaseInitializer.firebaseAuth;
    await firebaseAuth.signInWithCredential(authCredential);
  }
}
