import 'package:news_flash/models/article_model.dart';

class ArticleResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  ArticleResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) {
    return ArticleResponse(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: (json['articles'] as List)
          .map((articleJson) => Article.fromJson(articleJson))
          .toList(),
    );
  }
  
}