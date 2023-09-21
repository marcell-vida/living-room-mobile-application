import 'package:flutter/material.dart';
import 'package:living_room/screens/authentication/sign_in_screen.dart';
import 'package:living_room/screens/authentication/sign_up_screen.dart';
import 'package:living_room/screens/authentication/verify_email_screen.dart';
import 'package:living_room/screens/living_room/home_screen.dart';
import 'package:living_room/util/constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case AppRoutes.signIn:
        return MaterialPageRoute(settings: const RouteSettings(name: AppRoutes.signIn), builder: (_) => SignInScreen());
      case AppRoutes.signUp:
        return MaterialPageRoute(settings: const RouteSettings(name: AppRoutes.signUp), builder: (_) => SignUpScreen());
      case AppRoutes.verify:
        return MaterialPageRoute(settings: const RouteSettings(name: AppRoutes.verify), builder: (_) => const VerifyEmailScreen());
      case AppRoutes.home:
        return MaterialPageRoute(settings: const RouteSettings(name: AppRoutes.home), builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(settings: const RouteSettings(name: '/'), builder: (_) => SignInScreen());
    }
  }
}
