import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_flash/data/enum/news_category.dart';
import 'package:news_flash/data/helper/category_helper.dart';
import 'package:news_flash/models/news_response_model.dart';

class ApiService {
  final http.Client _httpClient;
  final String _baseUrl = dotenv.get('BASE_URL');
  final String _apiKey = dotenv.get('API_KEY');

  ApiService({required http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  String _buildUrl(NewsCategory category) {
    final String categoryName = CategoryHelper().convertCategoryName(category);
    if (category == NewsCategory.general) {
      String url =
          '${_baseUrl}top-headlines/sources?category=$categoryName&apiKey=$_apiKey';
      return url;
    } else {
      String url =
          '${_baseUrl}top-headlines/sources?category=$categoryName&apiKey=$_apiKey';
      return url;
    }
  }

  Future<List<NewsResponse>> getNewsByCategory(NewsCategory category) async {
    final String categoryName =
        CategoryHelper().convertCategoryName(category).capitalize();
    final methodName = 'get${categoryName}News';

    try {
      final response = await _httpClient
          .get(Uri.parse(_buildUrl(category)))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        return NewsResponse.fromJsonList(jsonData);
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

  Future<List<NewsResponse>> getNews() {
    return getNewsByCategory(NewsCategory.general);
  }

  Future<List<NewsResponse>> getBusinessNews() {
    return getNewsByCategory(NewsCategory.business);
  }

  Future<List<NewsResponse>> getEntertainmentNews() {
    return getNewsByCategory(NewsCategory.entertainment);
  }

  Future<List<NewsResponse>> getHealthNews() {
    return getNewsByCategory(NewsCategory.health);
  }

  Future<List<NewsResponse>> getScienceNews() {
    return getNewsByCategory(NewsCategory.science);
  }

  Future<List<NewsResponse>> getTechnologyNews() {
    return getNewsByCategory(NewsCategory.technology);
  }

  Future<List<NewsResponse>> getSportsNews() {
    return getNewsByCategory(NewsCategory.sports);
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
