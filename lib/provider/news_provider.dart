import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:news_flash/data/enum/news_category.dart';
import 'package:news_flash/data/repository/news_repository.dart';
import 'package:news_flash/models/article_model.dart';

class NewsProvider extends ChangeNotifier {
  final NewsRepository _newsRepository;

  NewsProvider(this._newsRepository);

  final ValueNotifier<List<Article>> _newsCategory = ValueNotifier(<Article>[]);
  final ValueNotifier<NewsCategory> _currentCategory = ValueNotifier(NewsCategory.general);
  final ValueNotifier<int> _currentPage = ValueNotifier(1);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  
  String _errorMessage = '';

  ValueNotifier<List<Article>> get newsCategory => _newsCategory;
  ValueNotifier<NewsCategory> get currentCategory => _currentCategory;
  ValueNotifier<int> get currentPage => _currentPage;
  ValueNotifier<bool> get isLoading => _isLoading;
  String get errorMessage => _errorMessage;


  Future<List<Article>> searchNews(String query, int page) async {
    final result = await _newsRepository.searchNews(query, page);
    _newsCategory.value = List.from(result);
    return result;
  }

  Future<void> loadNews([NewsCategory? category, int? page]) async {
    final targetCategory = category ?? _currentCategory.value;
    final targetPage = page ?? _currentPage.value;

    _isLoading.value = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final news = await _fetchNewsByCategory(targetCategory, targetPage);
      
      _newsCategory.value = List.from(news);
      _currentCategory.value = targetCategory;
      _currentPage.value = targetPage;
      
      log("Notícias carregadas: ${news.length} itens - Categoria: ${targetCategory.name} - Página: $targetPage");
    } catch (e) {
      _errorMessage = "Erro ao carregar notícias: $e";
      log("Erro ao carregar notícias: $e");
      _newsCategory.value = [];
    } finally {
      _isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> nextPage() async {
    await loadNews(_currentCategory.value, _currentPage.value + 1);
  }

  Future<void> previousPage() async {
    if (_currentPage.value > 1) {
      await loadNews(_currentCategory.value, _currentPage.value - 1);
    }
  }

  Future<void> changeCategory(NewsCategory category) async {
    log("Alterando categoria para: ${category.name}");
    await loadNews(category, 1);
  }

  Future<void> refresh() async {
    await loadNews(_currentCategory.value, _currentPage.value);
  }

  void clearCache() {
    _newsCategory.value = [];
    _currentPage.value = 1;
    _errorMessage = '';
    notifyListeners();
  }

  bool get canGoNext => _newsCategory.value.isNotEmpty;

  bool get canGoPrevious => _currentPage.value > 1;


  Future<List<Article>> _fetchNewsByCategory(NewsCategory category, int page) async {
    switch (category) {
      case NewsCategory.business:
        return _newsRepository.getBusinessNews(page);
      case NewsCategory.entertainment:
        return _newsRepository.getEntertainmentNews(page);
      case NewsCategory.health:
        return _newsRepository.getHealthNews(page);
      case NewsCategory.science:
        return _newsRepository.getScienceNews(page);
      case NewsCategory.sports:
        return _newsRepository.getSportsNews(page);
      case NewsCategory.technology:
        return _newsRepository.getTechnologyNews(page);
      case NewsCategory.general:
        return _newsRepository.getNews(page);
      default:
        return _newsRepository.getNews(page);
    }
  }

  @override
  void dispose() {
    _newsCategory.dispose();
    _currentCategory.dispose();
    _currentPage.dispose();
    _isLoading.dispose();
    super.dispose();
  }
}