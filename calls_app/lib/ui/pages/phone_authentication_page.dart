import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection/injection.dart';
import '../bloc/phone_auth/phone_auth_bloc.dart';
import 'calls_setup_page.dart';

class PhoneAuthenticationPage extends StatefulWidget {
  const PhoneAuthenticationPage({super.key});

  @override
  State<PhoneAuthenticationPage> createState() =>
      _PhoneAuthenticationPageState();
}

class _PhoneAuthenticationPageState extends State<PhoneAuthenticationPage> {
  final _phoneAuthBloc = getIt.get<PhoneAuthBloc>();

  final _phoneController = TextEditingController();
  final _smsController = TextEditingController();

  Future<void> _verifyPhone() async {
    _phoneAuthBloc.add(PhoneAuthVerifyPhone(_phoneController.text));
  }

  Future<void> _sendCode() async {
    _phoneAuthBloc.add(PhoneAuthVerifyCode(_smsController.text));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
        bloc: _phoneAuthBloc,
        listener: (context, state) {
          if (state is PhoneAuthPhoneVerified) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<CallsSetupPage>(
                builder: (_) => const CallsSetupPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  TextButton(
                    onPressed: _verifyPhone,
                    child: const Text('Verify phone'),
                  ),
                  if (state is PhoneAuthCodeSent)
                    Text(
                      'Code sent, verificationId - '
                      '${state.codeSentData.verificationId}',
                    )
                  else if (state is PhoneAuthVerifyPhoneError)
                    Text(state.error.toString()),
                  TextField(
                    controller: _smsController,
                    keyboardType: TextInputType.number,
                  ),
                  TextButton(
                    onPressed: _sendCode,
                    child: const Text('Send code'),
                  ),
                  if (state is PhoneAuthPhoneVerified)
                    const Text('Phone verified')
                  else if (state is PhoneAuthVerifyCodeError)
                    Text(state.error.toString()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
