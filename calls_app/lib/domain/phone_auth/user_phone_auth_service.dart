import '../../data/gate_ways/phone_auth/firebase_phone_auth_gate_way.dart';
import '../../data/gate_ways/user/firebase_user_gate_way.dart';
import '../../data/models/code_sent_data.dart';
import 'phone_auth_service.dart';

class UserPhoneAuthService implements PhoneAuthService {
  final _phoneAuthGateWay = FirebasePhoneAuthGateWay();
  final _userGateWay = FirebaseUserGateWay();

  @override
  Future<CodeSentData> verifyPhoneNumber(
    String phoneNumber, [
    int? resendingToken,
  ]) {
    return _phoneAuthGateWay.verifyPhoneNumber(phoneNumber, resendingToken);
  }

  @override
  Future<void> signInWithSmsCode(String verificationId, String smsCode) async {
    await _phoneAuthGateWay.signInWithSmsCode(verificationId, smsCode);
    final user = await _userGateWay.getCurrentUser();

    if (user == null) return;

    await _userGateWay.addUser(user);
  }
}
