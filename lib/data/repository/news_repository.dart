import 'dart:developer';
import 'package:news_flash/models/news_response_model.dart';
import 'package:news_flash/data/services/api_service.dart';

class NewsRepository {
  final ApiService _apiService;

  NewsRepository(this._apiService);

  Future<List<NewsResponse>> getNews() async {
    try {
      return await _apiService.getNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<NewsResponse>> getBusinessNews() async {
    try {
      return await _apiService.getBusinessNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<NewsResponse>> getEntertainmentNews() async {
    try {
      return await _apiService.getEntertainmentNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<NewsResponse>> getHealthNews() async {
    try {
      return await _apiService.getHealthNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<NewsResponse>> getScienceNews() async {
    try {
      return await _apiService.getScienceNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<NewsResponse>> getSportsNews() async {
    try {
      return await _apiService.getSportsNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<List<NewsResponse>> getTechnologyNews() async {
    try {
      return await _apiService.getTechnologyNews();
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }
}
