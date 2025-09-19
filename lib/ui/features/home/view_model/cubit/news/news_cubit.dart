import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_flash/ui/features/home/view_model/cubit/news/news_state.dart';
import 'package:news_flash/utils/enum/news_category.dart';
import 'package:news_flash/data/model/article_response.dart';
import 'package:news_flash/data/repository/news_repository.dart';
import 'package:news_flash/domain/models/article_model.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit(this._newsRepository) : super(InitialNewsState());

  final NewsRepository _newsRepository;

  List<Article> _newsCategory = [];
  NewsCategory _currentCategory = NewsCategory.general;
  int _currentPage = 1;
  int _topHeadlinesCurrentPage = 1;
  List<Article> _favoriteNews = [];
  List<Article> _topHeadlines = [];

  List<Article> get newsCategory => _newsCategory;
  List<Article> get favoriteNews => _favoriteNews;
  List<Article> get topHeadlines => _topHeadlines;
  NewsCategory get currentCategory => _currentCategory;
  int get currentPage => _currentPage;

  bool get canGoNext => _newsCategory.isNotEmpty;
  bool get canGoPrevious => _currentPage > 1;

  Future<void> loadTopHeadlines({int page = 1}) async {
    if (page == 1) {
      _topHeadlines.clear();
      _topHeadlinesCurrentPage = 1;
      emit(LoadingNewsState());
    }

    try {
      final headlines = await _newsRepository.getTopHeadlines(page);
      _topHeadlines.addAll(headlines.articles);
      emit(LoadedTopHeadlinesState(_topHeadlines));
      _topHeadlinesCurrentPage = page;
    } catch (e) {
      emit(ErrorNewsState(e.toString()));
    }
  }

  Future<void> nextTopHeadlinesPage() async {
    await loadTopHeadlines(page: _topHeadlinesCurrentPage + 1);
  }

  Future<ArticleResponse> searchNews(String query, int page) async {
    emit(LoadingNewsState());

    final result = await _newsRepository.searchNews(query, page);
    _newsCategory.clear();
    _newsCategory.addAll(result.articles);
    emit(LoadedNewsState(_newsCategory, _currentCategory, _currentPage));
    return result;
  }

  Future<void> loadNews([NewsCategory? category, int? page]) async {
    final targetCategory = category ?? _currentCategory;
    final targetPage = page ?? _currentPage;

    try {
      final news = await _fetchNewsByCategory(targetCategory, targetPage);
      _newsCategory.clear();
      _newsCategory.addAll(news.articles);
      _currentCategory = targetCategory;
      _currentPage = targetPage;
      emit(LoadedNewsState(_newsCategory, _currentCategory, _currentPage));
      log(
        "Notícias carregadas: ${news.totalResults} itens - Categoria: ${targetCategory.name} - Página: $targetPage",
      );
    } catch (e) {
      log("Erro ao carregar notícias: $e");
      emit(ErrorNewsState("Erro ao carregar notícias: $e"));
      _newsCategory.clear();
    }
  }

  Future<void> nextPage() async {
    await loadNews(_currentCategory, _currentPage + 1);
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      await loadNews(_currentCategory, _currentPage - 1);
    }
  }

  Future<void> changeCategory(NewsCategory category) async {
    log("Alterando categoria para: ${category.name}");
    await loadNews(category, 1);
  }

  Future<void> refresh() async {
    await loadNews(_currentCategory, _currentPage);
  }

  void toggleFavorite(Article article) {
    final isFavorite = _favoriteNews.contains(article);
    final updatedList = List<Article>.from(_favoriteNews);

    if (isFavorite) {
      updatedList.remove(article);
    } else {
      updatedList.add(article);
    }

    _favoriteNews = updatedList;
  }

  void deleteFavoriteNews(Article article) {
    _favoriteNews = _favoriteNews.where((a) => a != article).toList();
  }

  void clearCache() {
    _newsCategory.clear();
    _currentPage = 1;
  }

  Future<ArticleResponse> _fetchNewsByCategory(
    NewsCategory category,
    int page,
  ) async {
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
    }
  }

  @override
  void dispose() {
    _newsCategory.clear();
    _currentPage = 1;
    _currentCategory = NewsCategory.general;
  }
}
