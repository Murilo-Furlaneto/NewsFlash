import 'package:flutter/material.dart';
import 'package:news_flash/data/enum/news_category.dart';
import 'package:news_flash/data/repository/news_repository.dart';
import 'package:news_flash/data/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:news_flash/models/article_model.dart';
import 'package:news_flash/models/news_response_model.dart';

class NewsProvider extends ChangeNotifier {
  final NewsRepository _newsRepository = NewsRepository(
    ApiService(httpClient: http.Client()),
  );

  final List<Article> _newsCategory = [];
  List<Article> get newsCategory => _newsCategory;
  NewsCategory _currentCategory = NewsCategory.general;
  NewsCategory get currentCategory => _currentCategory;

  bool _isLoading = false;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  bool _isSuccess = false;

  void clearCache() {
    _newsCategory.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _newsCategory.clear();
    super.dispose();
  }

  Future<List<Article>> fetchNews(NewsCategory category) async {
    _currentCategory = category;
    _isLoading = true;
    notifyListeners();
    try {
      final news = await _fetchNewsByCategory(category);
      _isSuccess = true;
      _newsCategory.clear();
      _newsCategory.addAll(news);
      return _newsCategory;
    } catch (e) {
      _errorMessage = e.toString();
      Exception("Erro ao pesquisar notícias: $_errorMessage");
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Article>> _fetchNewsByCategory(NewsCategory category) async {
    switch (category) {
      case NewsCategory.business:
        return _newsRepository.getBusinessNews();
      case NewsCategory.entertainment:
        return _newsRepository.getEntertainmentNews();
      case NewsCategory.health:
        return _newsRepository.getHealthNews();
      case NewsCategory.science:
        return _newsRepository.getScienceNews();
      case NewsCategory.sports:
        return _newsRepository.getSportsNews();
      case NewsCategory.technology:
        return _newsRepository.getTechnologyNews();
      case NewsCategory.general:
        return _newsRepository.getNews();
      default:
        return _newsRepository.getNews();
    }
  }
}
