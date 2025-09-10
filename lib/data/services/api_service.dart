import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_flash/data/enum/news_category.dart';
import 'package:news_flash/data/helper/category_helper.dart';
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
          '${_baseUrl}everything?q=$categoryName&page=$page&apiKey=$_apiKey';
      return url;
    } else {
      String url =
          '${_baseUrl}everything?q=$categoryName&page=$page&apiKey=$_apiKey';
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
    } on SocketException {
      _logError("searchNews - Erro: Sem conexão com a Internet");
      throw Exception("Sem conexão com a Internet");
    } on HttpException {
      _logError("searchNews - Erro: Não foi possível encontrar as notícias");
      throw Exception("Não foi possível encontrar as notícias");
    } on FormatException {
      _logError("searchNews - Erro: Formato de resposta inválido");
      throw Exception("Formato de resposta inválido");
    } catch (e) {
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
    } on SocketException {
      _logError("$methodName - Erro: Sem conexão com a Internet");
      throw Exception("Sem conexão com a Internet");
    } on HttpException {
      _logError("$methodName - Erro: Não foi possível encontrar as notícias");
      throw Exception("Não foi possível encontrar as notícias");
    } on FormatException {
      _logError("$methodName - Erro: Formato de resposta inválido");
      throw Exception("Formato de resposta inválido");
    } catch (e) {
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

  void dispose() {
    _httpClient.close();
  }
}

/// Extensão para capitalizar strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
