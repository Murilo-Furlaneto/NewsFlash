import 'package:get_it/get_it.dart';
import 'package:news_flash/data/repository/news_repository.dart';
import 'package:news_flash/data/services/api_service.dart';
import 'package:news_flash/provider/news_provider.dart';
import 'package:http/http.dart' as http;
import 'package:news_flash/provider/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setUp() async {
  getIt.registerLazySingleton<NewsRepository>(() => NewsRepository(getIt<ApiService>()));
  getIt.registerLazySingleton<ApiService>(() => ApiService(httpClient: http.Client()));
  getIt.registerSingleton<NewsProvider>(NewsProvider(getIt<NewsRepository>()));
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<ThemeProvider>(ThemeProvider(sharedPreferences));
}
