import 'package:injectable/injectable.dart';

import '../../data/gate_ways/phone_auth/phone_auth_gate_way.dart';
import '../../data/gate_ways/user/user_gate_way.dart';
import '../../data/models/code_sent_data.dart';
import 'phone_auth_service.dart';

@LazySingleton(as: PhoneAuthService)
class UserPhoneAuthService implements PhoneAuthService {
  UserPhoneAuthService(this._phoneAuthGateWay, this._userGateWay);

  final PhoneAuthGateWay _phoneAuthGateWay;
  final UserGateWay _userGateWay;

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
