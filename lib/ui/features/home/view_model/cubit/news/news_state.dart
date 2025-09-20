import 'package:news_flash/utils/enum/news_category.dart';
import 'package:news_flash/domain/models/article_model.dart';

abstract class NewsState{}

class InitialNewsState extends NewsState{}

class LoadingNewsState extends NewsState{}

class LoadedNewsState extends NewsState {
  final List<Article> newsCategory;
  final NewsCategory currentCategory;
  final int currentPage;

  LoadedNewsState(this.newsCategory, this.currentCategory, this.currentPage);
}


class ErrorNewsState extends NewsState{
  final String errorMessage;

  ErrorNewsState(this.errorMessage);
}

class LoadedTopHeadlinesState extends NewsState {
  final List<Article> topHeadlines;

  LoadedTopHeadlinesState(this.topHeadlines);
}

class LoadedFavoriteNewsState extends NewsState {
  final List<Article> favoriteNews;

  LoadedFavoriteNewsState(this.favoriteNews);
}