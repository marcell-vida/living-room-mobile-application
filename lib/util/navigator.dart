import 'package:flutter/material.dart';
import 'package:living_room/screens/authentication/sign_in_screen.dart';
import 'package:living_room/screens/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case '/login':
        return MaterialPageRoute(settings: const RouteSettings(name: '/login'), builder: (_) => SignInScreen());
      case '/':
        return MaterialPageRoute(settings: const RouteSettings(name: '/'), builder: (_) => SignInScreen());
      default:
        return MaterialPageRoute(settings: const RouteSettings(name: '/'), builder: (_) => const HomeScreen());
    }
  }
}
