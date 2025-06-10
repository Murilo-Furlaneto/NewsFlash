import 'dart:developer';
import 'package:news_flash/data/services/api_service.dart';
import 'package:news_flash/models/article_model.dart';

class NewsRepository {
  final ApiService _apiService;

  NewsRepository(this._apiService);

  Future<List<Article>> getNews() async {
    try {
      return await _apiService.getNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getBusinessNews() async {
    try {
      return await _apiService.getBusinessNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getEntertainmentNews() async {
    try {
      return await _apiService.getEntertainmentNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getHealthNews() async {
    try {
      return await _apiService.getHealthNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getScienceNews() async {
    try {
      return await _apiService.getScienceNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getSportsNews() async {
    try {
      return await _apiService.getSportsNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getTechnologyNews() async {
    try {
      return await _apiService.getTechnologyNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }
}
