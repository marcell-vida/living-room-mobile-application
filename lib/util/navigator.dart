import 'package:flutter/material.dart';
import 'package:living_room/screens/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(settings: const RouteSettings(name: '/'), builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(settings: const RouteSettings(name: '/'), builder: (_) => const HomeScreen());
    }
  }
}
