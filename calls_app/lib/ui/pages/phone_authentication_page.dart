import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../injection/injection.dart';
import '../bloc/phone_auth/phone_auth_bloc.dart';
import '../theme/input_decoration.dart';
import 'calls_setup_page.dart';

class PhoneAuthenticationPage extends StatefulWidget {
  const PhoneAuthenticationPage({super.key});

  @override
  State<PhoneAuthenticationPage> createState() =>
      _PhoneAuthenticationPageState();
}

class _PhoneAuthenticationPageState extends State<PhoneAuthenticationPage> {
  final _phoneAuthBloc = getIt.get<PhoneAuthBloc>();

  final _phoneFocus = FocusNode();
  final _phoneController = TextEditingController();

  final _smsFocus = FocusNode();
  final _smsController = TextEditingController();

  Future<void> _verifyPhone() async {
    _phoneFocus.unfocus();
    _phoneAuthBloc.add(PhoneAuthVerifyPhone(_phoneController.text));
  }

  Future<void> _sendCode() async {
    _smsFocus.unfocus();
    final code = _smsController.text.replaceAll(' ', '');
    _phoneAuthBloc.add(PhoneAuthVerifyCode(code));
  }

  void _phoneAuthListener(BuildContext context, PhoneAuthState state) {
    if (state is PhoneAuthPhoneVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<CallsSetupPage>(
          builder: (_) => const CallsSetupPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneFocus.dispose();
    _phoneController.dispose();
    _smsFocus.dispose();
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.background.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              children: [
                const Spacer(),
                Assets.images.logo.svg(),
                const SizedBox(height: 43),
                Text(
                  'Welcome to TBR Group In App Calls',
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
                  bloc: _phoneAuthBloc,
                  listener: _phoneAuthListener,
                  builder: (context, state) {
                    if (state is PhoneAuthCodeSent) {
                      return _SmsCodeInput(
                        state: state,
                        focus: _smsFocus,
                        controller: _smsController,
                        onDone: _sendCode,
                      );
                    }
                    return _PhoneInput(
                      state: state,
                      focus: _phoneFocus,
                      controller: _phoneController,
                      onSend: _verifyPhone,
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Spacer(),
                KeyboardVisibilityBuilder(
                  builder: (context, visible) {
                    if (visible) return const SizedBox.shrink();

                    return Column(
                      children: [
                        Text(
                          'Read our Privacy Policy. Tap “Agree & Continue” to '
                          'accept the Terms of Service.',
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 54),
                        Text(
                          'from\nTBR Group',
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  const _PhoneInput({
    required PhoneAuthState state,
    required FocusNode focus,
    required TextEditingController controller,
    required VoidCallback onSend,
  })  : _state = state,
        _focus = focus,
        _controller = controller,
        _onSend = onSend;

  final PhoneAuthState _state;
  final FocusNode _focus;
  final TextEditingController _controller;
  final VoidCallback _onSend;

  @override
  Widget build(BuildContext context) {
    final state = _state;

    return Column(
      children: [
        Text(
          'Enter your phone number',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 26),
        TextField(
          focusNode: _focus,
          controller: _controller,
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                letterSpacing: 1.5,
              ),
          inputFormatters: [
            MaskTextInputFormatter(
              mask: '+ ### ### ### ### ###',
              filter: {'#': RegExp('[0-9]')},
            ),
          ],
          decoration: phoneInputDecoration(
            hintText: '+ --- --- --- --- ---',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        if (state is PhoneAuthVerifyPhoneError) ...[
          const SizedBox(height: 16),
          Text(
            state.error.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(
                  color: AppColors.red,
                ),
          ),
        ],
        const SizedBox(height: 67),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ElevatedButton(
            onPressed: state is PhoneAuthVerifyPhoneLoading ? null : _onSend,
            child: state is PhoneAuthVerifyPhoneLoading
                ? const Center(child: CircularProgressIndicator())
                : const Text('Send'),
          ),
        ),
      ],
    );
  }
}

class _SmsCodeInput extends StatelessWidget {
  const _SmsCodeInput({
    required PhoneAuthCodeSent state,
    required FocusNode focus,
    required TextEditingController controller,
    required VoidCallback onDone,
  })  : _state = state,
        _focus = focus,
        _controller = controller,
        _onDone = onDone;

  final PhoneAuthCodeSent _state;
  final FocusNode _focus;
  final TextEditingController _controller;
  final VoidCallback _onDone;

  @override
  Widget build(BuildContext context) {
    final state = _state;

    return Column(
      children: [
        Text(
          'Enter SMS code',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 26),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 52),
          child: TextField(
            focusNode: _focus,
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 26,
                  letterSpacing: 1.5,
                ),
            inputFormatters: [
              MaskTextInputFormatter(
                mask: '### ###',
                filter: {'#': RegExp('[0-9]')},
              ),
            ],
            decoration: phoneInputDecoration(
              hintText: '--- ---',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 26,
                    letterSpacing: 1.5,
                  ),
            ),
          ),
        ),
        if (state is PhoneAuthVerifyCodeError) ...[
          const SizedBox(height: 16),
          Text(
            state.error.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(
                  color: AppColors.red,
                ),
          ),
        ],
        const SizedBox(height: 67),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ElevatedButton(
            onPressed: state is PhoneAuthVerifyCodeLoading ? null : _onDone,
            child: state is PhoneAuthVerifyCodeLoading
                ? const Center(child: CircularProgressIndicator())
                : const Text('Done'),
          ),
        ),
      ],
    );
  }
}
