import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:skin_detection/utilites/app_colors.dart';
import 'package:skin_detection/utilites/app_strings.dart';

import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: AppColors.primaryColor,
      duration: 300,
      splash: const Text(
        AppStrings.splashText,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
      ),
      nextScreen:  const HomeScreen(),
      splashTransition: SplashTransition.slideTransition,

    );
  }
}
