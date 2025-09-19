class NewsResponse {
  final String id;
  final String name;
  final String url;
  final String description;
  final String category;
  final String language;
  final String country;

  NewsResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.category,
    required this.language,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'category': category,
      'language': language,
      'country': country,
    };
  }

  static List<NewsResponse> fromJsonList(Map<String, dynamic> map) {
    final List<dynamic>? sourcesList = map['sources'];

    if (sourcesList == null || sourcesList.isEmpty) {
      throw Exception("Sources list is empty or null");
    }

    return sourcesList.map((source) {
      return NewsResponse(
        id: source['id'] as String? ?? '',
        name: source['name'] as String? ?? '',
        description: source['description'] as String? ?? '',
        url: source['url'] as String? ?? '',
        category: source['category'] as String? ?? '',
        language: source['language'] as String? ?? '',
        country: source['country'] as String? ?? '',
      );
    }).toList();
  }
}
