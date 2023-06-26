import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../injection/injection.dart';
import '../bloc/call/call_bloc.dart';
import '../bloc/navigation/bottom_navigation_page.dart';
import '../bloc/navigation/navigation_cubit.dart';
import '../widgets/phone_input.dart';
import 'phone_authentication_page.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  final _callBlock = getIt.get<CallBloc>();

  final _phoneFocus = FocusNode();
  final _phoneController = TextEditingController();

  Future<void> _call() async {
    _phoneFocus.unfocus();
    _callBlock.add(InitiateCall(_phoneController.text));
  }

  @override
  void dispose() {
    _phoneFocus.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallBloc, CallState>(
      bloc: _callBlock,
      builder: (context, state) {
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _AppBar(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: PhoneInput(
                        title: 'Enter the phone number you want to call',
                        focus: _phoneFocus,
                        controller: _phoneController,
                        isLoading: state is CallInitializing,
                        buttonText: 'Call',
                        onEnter: _call,
                        errorText: state is CallInitializeError
                            ? state.error.toString()
                            : null,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget {
  final _navigationCubit = getIt.get<NavigationCubit>();

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<PhoneAuthenticationPage>(
        builder: (context) => const PhoneAuthenticationPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => _logout(context),
          child: Text(
            'Log out',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.black2,
                ),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () =>
              _navigationCubit.navigateTo(BottomNavigationPage.settings.index),
          child: Text(
            'My Profile',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.black2,
                ),
          ),
        ),
      ],
    );
  }
}
