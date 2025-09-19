import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_flash/utils/enum/news_category.dart';
import 'package:news_flash/utils/helper/category_helper.dart';
import 'package:news_flash/data/model/article_response.dart';

class ApiService {
  final http.Client _httpClient;
  final String _baseUrl = dotenv.get('BASE_URL');
  final String _apiKey = dotenv.get('API_KEY');

  ApiService({required http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  String _buildUrl(NewsCategory category, int page) {
    final String categoryName = CategoryHelper().convertCategoryName(category);
    if (category == NewsCategory.general) {
      String url =
          '${_baseUrl}top-headlines?category=$categoryName&page=$page&apiKey=$_apiKey';
      return url;
    } else {
      String url =
          '${_baseUrl}top-headlines?category=$categoryName&page=$page&apiKey=$_apiKey';
      return url;
    }
  }

  Future<ArticleResponse> searchNews(String query, int page) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${_baseUrl}everything?q=$query&page=$page&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return ArticleResponse.fromJson(jsonData);
      } else {
        _logError(
          "searchNews - Falha com código de status: ${response.statusCode}",
        );
        throw Exception("Erro ao carregar as notícias: ${response.statusCode}");
      }
    }  catch (e) {
      _logError("searchNews - Erro inesperado: ${e.toString()}");
      throw Exception("Erro inesperado: $e");
    }
  }

  Future<ArticleResponse> getNewsByCategory(
    NewsCategory category,
    int page,
  ) async {
    final String categoryName =
        CategoryHelper().convertCategoryName(category).capitalize();
    final methodName = 'get${categoryName}News';

    try {
      final response = await _httpClient.get(
        Uri.parse(_buildUrl(category, page)),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return ArticleResponse.fromJson(jsonData);
      } else {
        _logError(
          "$methodName - Falha com código de status: ${response.statusCode}",
        );
        throw Exception("Erro ao carregar as notícias: ${response.statusCode}");
      }
    }  catch (e) {
      _logError("$methodName - Erro inesperado: ${e.toString()}");
      throw Exception("Erro inesperado: $e");
    }
  }

  void _logError(String message) {
    log("[ApiService] $message");
  }

  Future<ArticleResponse> getNews(int page) {
    return getNewsByCategory(NewsCategory.general, page);
  }

  Future<ArticleResponse> getBusinessNews(int page) {
    return getNewsByCategory(NewsCategory.business, page);
  }

  Future<ArticleResponse> getEntertainmentNews(int page) {
    return getNewsByCategory(NewsCategory.entertainment, page);
  }

  Future<ArticleResponse> getHealthNews(int page) {
    return getNewsByCategory(NewsCategory.health, page);
  }

  Future<ArticleResponse> getScienceNews(int page) {
    return getNewsByCategory(NewsCategory.science, page);
  }

  Future<ArticleResponse> getTechnologyNews(int page) {
    return getNewsByCategory(NewsCategory.technology, page);
  }

  Future<ArticleResponse> getSportsNews(int page) {
    return getNewsByCategory(NewsCategory.sports, page);
  }

  Future<ArticleResponse> getTopHeadlines(int page) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${_baseUrl}top-headlines?country=us&page=$page&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return ArticleResponse.fromJson(jsonData);
      } else {
        _logError(
          "getTopHeadlines - Falha com código de status: ${response.statusCode}",
        );
        throw Exception("Erro ao carregar as notícias: ${response.statusCode}");
      }
    } catch (e) {
      _logError("getTopHeadlines - Erro inesperado: ${e.toString()}");
      throw Exception("Erro inesperado: $e");
    }
  }

  void dispose() {
    _httpClient.close();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
