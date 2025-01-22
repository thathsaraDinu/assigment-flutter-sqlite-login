import 'package:assignmentapp/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:assignmentapp/screens/home_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/login': (context) => const LoginPage(),
      '/': (context) => const HomeScreen(),
    };
  }
}
