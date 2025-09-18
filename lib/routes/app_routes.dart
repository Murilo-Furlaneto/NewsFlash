import 'package:flutter/material.dart';
import 'package:news_flash/view/home/main_screen.dart';
import 'package:news_flash/view/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';


  Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    main: (context) => const MainScreen(),
  };
}

