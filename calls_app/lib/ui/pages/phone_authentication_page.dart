import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/phone_auth/user_phone_auth_service.dart';
import 'calls_setup_page.dart';

class PhoneAuthenticationPage extends StatefulWidget {
  const PhoneAuthenticationPage({Key? key}) : super(key: key);

  @override
  State<PhoneAuthenticationPage> createState() =>
      _PhoneAuthenticationPageState();
}

class _PhoneAuthenticationPageState extends State<PhoneAuthenticationPage> {
  final _phoneAuthService = UserPhoneAuthService();

  final _phoneController = TextEditingController();
  final _smsController = TextEditingController();

  String? _sendCodeState;
  String? _verificationId;

  String? _phoneVerifiedState;

  Future<void> _verifyPhone() async {
    try {
      final codeSentData =
          await _phoneAuthService.verifyPhoneNumber(_phoneController.text);
      setState(() {
        _verificationId = codeSentData.verificationId;
        _sendCodeState = 'Code sent, verificationId - $_verificationId';
      });
    } catch (e) {
      setState(() => _sendCodeState = e.toString());
    }
  }

  Future<void> _sendCode() async {
    try {
      await _phoneAuthService.signInWithSmsCode(
        _verificationId!,
        _smsController.text,
      );
      setState(() => _phoneVerifiedState = 'Phone verified');
      unawaited(
        Navigator.push(
          context,
          MaterialPageRoute<CallsSetupPage>(builder: (_) => CallsSetupPage()),
        ),
      );
    } catch (e) {
      setState(() => _phoneVerifiedState = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              if (_sendCodeState != null) Text(_sendCodeState!),
              TextField(
                controller: _smsController,
                keyboardType: TextInputType.number,
              ),
              TextButton(
                onPressed: _sendCode,
                child: const Text('Send code'),
              ),
              if (_phoneVerifiedState != null) Text(_phoneVerifiedState!),
            ],
          ),
        ),
      ),
    );
  }
}
