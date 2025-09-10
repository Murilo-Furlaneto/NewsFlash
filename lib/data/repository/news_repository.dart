import 'dart:developer';
import 'package:news_flash/data/model/article_response.dart';
import 'package:news_flash/data/services/api_service.dart';

class NewsRepository {
  final ApiService _apiService;

  NewsRepository(this._apiService);

  Future<ArticleResponse> getNews(int page) async {
    try {
      return await _apiService.getNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<ArticleResponse> getBusinessNews(int page) async {
    try {
      return await _apiService.getBusinessNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<ArticleResponse> getEntertainmentNews(int page) async {
    try {
      return await _apiService.getEntertainmentNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<ArticleResponse> getHealthNews(int page) async {
    try {
      return await _apiService.getHealthNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<ArticleResponse> getScienceNews(int page) async {
    try {
      return await _apiService.getScienceNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<ArticleResponse> getSportsNews(int page) async {
    try {
      return await _apiService.getSportsNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<ArticleResponse> getTechnologyNews(int page) async {
    try {
      return await _apiService.getTechnologyNews(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  Future<ArticleResponse> searchNews(String query, int page) async {
    try {
      return await _apiService.searchNews(query, page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }
}
