import 'package:flutter/material.dart';

import '../gen/colors.gen.dart';
import '../gen/fonts.gen.dart';
import 'pages/initial_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TBR In App Calls Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
        useMaterial3: true,
        fontFamily: AppFonts.poppins,
        scaffoldBackgroundColor: AppColors.white,
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
            height: 1.5,
          ),
          titleSmall: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
            height: 1.5,
          ),
        ),
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: AppFonts.geometria,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
            height: 1.25,
          ),
          bodyMedium: TextStyle(
            fontFamily: AppFonts.geometria,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray2,
            height: 1.25,
          ),
          bodySmall: TextStyle(
            fontFamily: AppFonts.geometria,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
            height: 1.25,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.white,
            textStyle: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      home: InitialPage(),
    );
  }
}
