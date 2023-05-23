import '../../data/models/code_sent_data.dart';

abstract class PhoneAuthService {
  Future<CodeSentData> verifyPhoneNumber(
    String phoneNumber, [
    int? resendingToken,
  ]);

  Future<void> signInWithSmsCode(String verificationId, String smsCode);
}
