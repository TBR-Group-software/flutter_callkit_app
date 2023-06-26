import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../injection/injection.dart';
import '../bloc/call_kit/call_kit_cubit.dart';
import '../bloc/navigation/bottom_navigation_page.dart';
import '../bloc/navigation/navigation_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _save() {
    // TODO(Nikita): Implement saving.
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _AppBar(onSave: _save),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _CallKitSetup(),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  _AppBar({required VoidCallback onSave}) : _onSave = onSave;

  final _navigationCubit = getIt.get<NavigationCubit>();

  final VoidCallback _onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () =>
                  _navigationCubit.navigateTo(BottomNavigationPage.calls.index),
              child: Assets.icons.back.svg(),
            ),
          ),
        ),
        Expanded(
          child: Align(
            child: Text(
              'My Profile',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.black2,
                  ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _onSave,
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.green,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CallKitSetup extends StatelessWidget {
  final _callKitCubit = getIt.get<CallKitCubit>();

  /// Retries the CallKit initialization.
  void _retryInit() {
    _callKitCubit.initTelecomServices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallKitCubit, CallKitState>(
      bloc: _callKitCubit,
      builder: (context, state) {
        if (state is CallKitInitialized) {
          return Text(
            'CallKit setup completed. You can receive calls from other users.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          );
        } else if (state is CallKitNotInitialized || state is CallKitError) {
          return Column(
            children: [
              if (state is CallKitNotInitialized) ...[
                if (Platform.isIOS)
                  Text(
                    "CallKit setup failed, other users can't call you. May be "
                    'you are not sign in or there was an issue of getting your '
                    'IPhone VoIP token.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                else
                  Text(
                    "CallKit setup failed, other users can't call you. May be "
                    'you are not sign in or rejected to give Notifications or '
                    'Phone permissions.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ] else if (state is CallKitError) ...[
                Text(
                  state.error.toString(),
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.red),
                ),
              ],
              const SizedBox(height: 67),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ElevatedButton(
                  onPressed: _retryInit,
                  child: const Text('Try again'),
                ),
              ),
            ],
          );
        }
        return Column(
          children: <Widget>[
            Text(
              'CallKit is setting up. Please wait...',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        );
      },
    );
  }
}
