import 'package:flutter/material.dart';
import 'package:living_room/screens/authentication/sign_in_screen.dart';
import 'package:living_room/screens/authentication/sign_up_screen.dart';
import 'package:living_room/screens/home_screen.dart';
import 'package:living_room/util/constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case AppRoutes.signIn:
        return MaterialPageRoute(settings: const RouteSettings(name: AppRoutes.signIn), builder: (_) => SignInScreen());
      case AppRoutes.signUp:
        return MaterialPageRoute(settings: const RouteSettings(name: AppRoutes.signUp), builder: (_) => SignUpScreen());
      case '/':
        return MaterialPageRoute(settings: const RouteSettings(name: '/'), builder: (_) => SignInScreen());
      default:
        return MaterialPageRoute(settings: const RouteSettings(name: '/'), builder: (_) => const HomeScreen());
    }
  }
}
