import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../injection/injection.dart';
import '../bloc/call/call_bloc.dart';
import '../bloc/call_kit/call_kit_cubit.dart';
import '../bloc/navigation/bottom_navigation_page.dart';
import '../bloc/navigation/navigation_cubit.dart';
import 'calls_page.dart';
import 'settings_page.dart';
import 'video_call_page.dart';

class NavigationPage extends StatelessWidget {
  NavigationPage({super.key});

  static const _pages = [
    CallsPage(),
    SettingsPage(),
  ];

  final _callBlock = getIt.get<CallBloc>();
  final _navigationCubit = getIt.get<NavigationCubit>();

  // Need here just to launch the initTelecomServices method.
  // ignore: unused_field
  final _callKitCubit = getIt.get<CallKitCubit>();

  void _openVideoCallPage(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<VideoCallPage>(
        builder: (_) => const VideoCallPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallBloc, CallState>(
      bloc: _callBlock,
      listenWhen: (previous, current) {
        if (previous.runtimeType != current.runtimeType) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CallActive) {
          _openVideoCallPage(context);
        }
      },
      child: BlocBuilder<NavigationCubit, BottomNavigationPage>(
        bloc: _navigationCubit,
        builder: (context, state) {
          return Scaffold(
            body: _pages[state.index],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.index,
              onTap: _navigationCubit.navigateTo,
              items: [
                BottomNavigationBarItem(
                  label: 'Calls',
                  icon: Assets.icons.phone.svg(),
                  activeIcon: Assets.icons.phone.svg(
                    colorFilter: const ColorFilter.mode(
                      AppColors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Settings',
                  icon: Assets.icons.settings.svg(),
                  activeIcon: Assets.icons.settings.svg(
                    colorFilter: const ColorFilter.mode(
                      AppColors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
