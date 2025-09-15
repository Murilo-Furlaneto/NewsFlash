import 'package:flutter/material.dart';
import 'package:news_flash/view/home/home_screen.dart';
import 'package:news_flash/view/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';


  Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
  };
}
