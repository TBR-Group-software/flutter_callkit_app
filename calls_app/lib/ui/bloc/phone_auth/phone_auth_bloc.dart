import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/code_sent_data.dart';
import '../../../domain/phone_auth/phone_auth_service.dart';
import '../../../utils/parse_phone_number.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

@injectable
class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  PhoneAuthBloc(this._phoneAuthService) : super(PhoneAuthInitial()) {
    on<PhoneAuthVerifyPhone>(_onPhoneAuthVerifyPhoneEvent);
    on<PhoneAuthVerifyCode>(_onPhoneAuthVerifyCodeEvent);
  }

  final PhoneAuthService _phoneAuthService;

  Future<void> _onPhoneAuthVerifyPhoneEvent(
    PhoneAuthVerifyPhone event,
    Emitter<PhoneAuthState> emit,
  ) async {
    final phone = parsePhoneNumber(event.phoneNumber);
    if (phone == null) {
      emit(PhoneAuthVerifyPhoneError('Invalid phone number'));
      return;
    }

    final phoneString = '+$phone';

    emit(PhoneAuthVerifyPhoneLoading());

    try {
      final codeSentData =
          await _phoneAuthService.verifyPhoneNumber(phoneString);

      emit(PhoneAuthCodeSent(codeSentData));
    } catch (e) {
      emit(PhoneAuthVerifyPhoneError(e));
    }
  }

  Future<void> _onPhoneAuthVerifyCodeEvent(
    PhoneAuthVerifyCode event,
    Emitter<PhoneAuthState> emit,
  ) async {
    final localState = state;
    if (localState is! PhoneAuthCodeSent) return;

    emit(PhoneAuthVerifyCodeLoading(localState.codeSentData));

    try {
      await _phoneAuthService.signInWithSmsCode(
        localState.codeSentData.verificationId,
        event.smsCode,
      );

      emit(PhoneAuthPhoneVerified());
    } catch (e) {
      emit(PhoneAuthVerifyCodeError(e, localState.codeSentData));
    }
  }
}
