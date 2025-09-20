import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:news_flash/data/model/article_response.dart';
import 'package:news_flash/data/services/remote/api_service.dart';
import 'package:news_flash/domain/models/article_model.dart';

class NewsRepository {
  final ApiService _apiService;
  final Box<Article> _box = Hive.box<Article>('favorite_articles');

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

  Future<ArticleResponse> getTopHeadlines(int page) async {
    try {
      return await _apiService.getTopHeadlines(page);
    } catch (e) {
      log("Erro ao carregar as notícias: $e");
      throw Exception("Erro ao carregar as notícias: $e");
    }
  }

  List<Article> getFavoriteNews() {
    try {
      log("${_box.values.length}");
      return _box.values.toList();
    } catch (e) {
      log("Erro ao carregar as notícias favoritas: $e");
      throw Exception("Erro ao carregar as notícias favoritas: $e");
    }
  }

  Future<void> addFavoriteNews(Article article) async {
    try {
      await _box.put(article.url, article);
    } catch (e) {
      log("Erro ao adicionar notícia favorita: $e");
      throw Exception("Erro ao adicionar notícia favorita: $e");
    }
  }

  Future<void> deleteFavoriteNews(Article article) async {
    try {
      await _box.delete(article.url);
    } catch (e) {
      log("Erro ao remover notícia favorita: $e");
      throw Exception("Erro ao remover notícia favorita: $e");
    }
  }

  Future<void> clearHistory() async {
    try {
      await _box.deleteAll(_box.keys);
    } catch (e) {
      log("Erro ao limpar histórico: $e");
      throw Exception("Erro ao limpar histórico: $e");
    }
  }
}