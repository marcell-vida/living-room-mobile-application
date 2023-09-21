import 'package:flutter/material.dart';

class Constants {
  static get borderRadius => BorderRadius.circular(20);

  static get borderRadiusLarge => BorderRadius.circular(50);

  static double borderWidth = 2.0;
}

class AppPaddings {
  static get screenSide => const EdgeInsets.symmetric(horizontal: 25.0);

  static get cardAllAround =>
      const EdgeInsets.only(left: 20.0, right: 20.0, top: 23.0, bottom: 23.0);

  static get inputField =>
      const EdgeInsets.only(left: 20, top: 16, bottom: 15, right: 20);

  static get screenAllAround =>
      const EdgeInsets.only(left: 25.0, right: 25.0, top: 26.0, bottom: 0);
}

class AppColors {
  static const Color blue = Color(0xFF0b84a5);
  static const Color sand = Color(0xFFf6c85f);
  static const Color purple = Color(0xFF6f4e7c);
  static const Color purple50 = Color(0xFFbaa0c4);
  static const Color red = Color(0xffDE5B5B);
  static const Color black = Color(0xFF222222);
  static const Color black36 = Color(0x5c222222);
  static const Color white = Color(0xffFFFFFF);
  static Color whiteOp30 = white.withOpacity(0.3);
  static const Color grey = Color(0xFF888888);
  static const Color grey2 = Color(0xFFAAAAAA);
  static const Color grey3 = Color(0xFFD2D2D2);
}

class AppRoutes{
  static const signIn = '/signIn';
  static const signUp = '/signUp';
}