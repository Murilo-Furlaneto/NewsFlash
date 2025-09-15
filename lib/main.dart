import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_flash/data/getIt/init_get_it.dart';
import 'package:news_flash/provider/news/news_provider.dart';
import 'package:news_flash/provider/theme/theme_provider.dart';
import 'package:news_flash/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  final prefs = await SharedPreferences.getInstance();
  setUp();
  runApp(MyApp(preferences: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.preferences});
  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(preferences)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'News Flash',
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.blue,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.blue,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
            ),
            themeMode: themeProvider.themeMode,
            routes: AppRoutes().routes,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}