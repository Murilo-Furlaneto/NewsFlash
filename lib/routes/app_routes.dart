import 'package:flutter/material.dart';
import 'package:news_flash/view/home/home_view.dart';
import 'package:news_flash/view/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String newsDetails = '/news-details';

  Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeView(),
    // newsDetails: (context) => const NewsDetailsScreen(),
  };
}
