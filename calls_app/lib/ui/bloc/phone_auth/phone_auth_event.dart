part of 'phone_auth_bloc.dart';

@immutable
abstract class PhoneAuthEvent {}

class PhoneAuthVerifyPhone extends PhoneAuthEvent {
  PhoneAuthVerifyPhone(this.phoneNumber);

  final String phoneNumber;
}

class PhoneAuthVerifyCode extends PhoneAuthEvent {
  PhoneAuthVerifyCode(this.smsCode);

  final String smsCode;
}
