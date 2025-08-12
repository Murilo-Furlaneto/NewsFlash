import 'dart:developer';
import 'package:news_flash/data/services/api_service.dart';
import 'package:news_flash/models/article_model.dart';

class NewsRepository {
  final ApiService _apiService;

  NewsRepository(this._apiService);

  Future<List<Article>> getNews(int page) async {
    try {
      return await _apiService.getNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getBusinessNews(int page) async {
    try {
      return await _apiService.getBusinessNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getEntertainmentNews(int page) async {
    try {
      return await _apiService.getEntertainmentNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getHealthNews(int page) async {
    try {
      return await _apiService.getHealthNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getScienceNews(int page) async {
    try {
      return await _apiService.getScienceNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getSportsNews(int page) async {
    try {
      return await _apiService.getSportsNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<Article>> getTechnologyNews(int page) async {
    try {
      return await _apiService.getTechnologyNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }
}
