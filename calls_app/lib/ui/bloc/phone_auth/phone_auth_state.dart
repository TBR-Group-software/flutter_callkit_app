part of 'phone_auth_bloc.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

/// Indicates that user sent the phone number for verification. If verification
/// passed the [PhoneAuthCodeSent] will be emitted.
class PhoneAuthVerifyPhoneLoading extends PhoneAuthState {}

/// Indicates that error occurred during phone number verification.
class PhoneAuthVerifyPhoneError extends PhoneAuthState {
  PhoneAuthVerifyPhoneError(this.error);

  final Object error;
}

/// Indicates that the code was sent to the user's phone number.
class PhoneAuthCodeSent extends PhoneAuthState {
  PhoneAuthCodeSent(this.codeSentData);

  final CodeSentData codeSentData;
}

/// Indicates that user sent the code for verification. If verification passed
/// the [PhoneAuthPhoneVerified] will be emitted.
class PhoneAuthVerifyCodeLoading extends PhoneAuthCodeSent {
  PhoneAuthVerifyCodeLoading(super.codeSentData);
}

/// Indicates that error occurred during code verification.
class PhoneAuthVerifyCodeError extends PhoneAuthCodeSent {
  PhoneAuthVerifyCodeError(this.error, super.codeSentData);

  final Object error;
}

/// Indicates that the phone number was verified. Should be emitted only after
/// phone verification and code verification.
class PhoneAuthPhoneVerified extends PhoneAuthState {}
