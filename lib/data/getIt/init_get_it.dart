import 'package:get_it/get_it.dart';
import 'package:news_flash/data/repository/news_repository.dart';
import 'package:news_flash/data/services/api_service.dart';
import 'package:news_flash/provider/news_provider.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

void setUp() {
  // Register services
  getIt.registerLazySingleton<NewsRepository>(() => NewsRepository(
    getIt<ApiService>(),
  ));
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(httpClient: http.Client()),
  );

  // Register providers
  getIt.registerSingleton<NewsProvider>(NewsProvider());
}
