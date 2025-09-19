import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_flash/routing/routes/app_routes.dart';
import 'package:news_flash/ui/features/home/view_model/cubit/news/news_cubit.dart';
import 'package:news_flash/config/di/init_get_it.dart';
import 'package:news_flash/data/repository/news_repository.dart';
import 'package:news_flash/ui/features/theme/view_model/theme/theme_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NewsCubit(getIt<NewsRepository>())),
        BlocProvider(create: (_) => ThemeCubit(preferences)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
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
            themeMode: state.themeMode,
            routes: AppRoutes().routes,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}
