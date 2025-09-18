import 'package:get_it/get_it.dart';
import 'package:news_flash/cubit/news/news_cubit.dart';
import 'package:news_flash/cubit/theme/theme_cubit.dart';
import 'package:news_flash/data/repository/news_repository.dart';
import 'package:news_flash/data/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setUp() async {
  getIt.registerLazySingleton<NewsRepository>(() => NewsRepository(getIt<ApiService>()));
  getIt.registerLazySingleton<ApiService>(() => ApiService(httpClient: http.Client()));
  getIt.registerSingleton<NewsCubit>(NewsCubit(getIt<NewsRepository>()));
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<ThemeCubit>(ThemeCubit(sharedPreferences));
}
