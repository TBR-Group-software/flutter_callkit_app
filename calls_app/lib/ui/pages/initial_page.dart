import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';
import '../../injection/injection.dart';
import '../bloc/user_log_in/user_log_in_cubit.dart';
import 'calls_setup_page.dart';
import 'phone_authentication_page.dart';

class InitialPage extends StatelessWidget {
  InitialPage({super.key});

  final _userLogInCubit = getIt.get<UserLogInCubit>();

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
        child: BlocConsumer<UserLogInCubit, UserLogInState>(
          bloc: _userLogInCubit,
          listener: (context, state) {
            if (state is UserLoggedIn) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<CallsSetupPage>(
                  builder: (_) => const CallsSetupPage(),
                ),
              );
            } else if (state is UserLoggedOut) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<PhoneAuthenticationPage>(
                  builder: (_) => const PhoneAuthenticationPage(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is UserLogInLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
