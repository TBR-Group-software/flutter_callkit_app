import '../../models/code_sent_data.dart';

abstract class PhoneAuthGateWay {
  /// Phone number verification.
  Future<CodeSentData> verifyPhoneNumber(
    String phoneNumber, [
    int? resendingToken,
  ]);

  /// Sign in with verification ID and SMS code.
  Future<void> signInWithSmsCode(String verificationId, String smsCode);
}
