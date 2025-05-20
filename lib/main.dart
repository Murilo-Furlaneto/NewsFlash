import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_flash/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Flash',
      theme: ThemeData(
        primaryColor: Colors.blue,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routes: AppRoutes().routes,
      initialRoute: AppRoutes.splash,
    );
  }
}
