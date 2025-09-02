import 'package:flutter/material.dart';
import 'package:news_flash/view/home/home_screen.dart';
import 'package:news_flash/view/news/news_details_page.dart';
import 'package:news_flash/view/profile/profile_screen.dart';
import 'package:news_flash/view/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String newsDetails = '/news-details';
  static const String profile = '/profile';


  Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
     newsDetails: (context) =>  NewsDetailsPage(),
    profile: (context) =>  ProfileScreen(),
  };
}
