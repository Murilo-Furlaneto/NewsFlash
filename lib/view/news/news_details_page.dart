import 'package:flutter/material.dart';
import 'package:news_flash/cubit/news/news_cubit.dart';
import 'package:news_flash/models/article_model.dart';
import 'package:news_flash/view/news/article_webview_page.dart';

class NewsDetailsPage extends StatefulWidget {
  const NewsDetailsPage({super.key, required this.article, required this.cubit});

  final Article article;
  final NewsCubit cubit;

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage>
    with SingleTickerProviderStateMixin {
  bool isFavorited = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
      if (isFavorited) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      widget.cubit.toggleFavorite(widget.article);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        title: Text(article.source.name),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 32,
            icon: ScaleTransition(
              scale: Tween<double>(begin: 1, end: 1.3).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.primary,
              ),
            ),
            onPressed: toggleFavorite,
            tooltip: isFavorited ? 'Desfavoritar' : 'Favoritar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  article.urlToImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 220,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      height: 220,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image, size: 64),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              article.title,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (article.author != null && article.author!.isNotEmpty)
                  Expanded(
                    child: Text(
                      'Por ${article.author}',
                      style: textTheme.bodyMedium
                          ?.copyWith(fontStyle: FontStyle.italic),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Text(
                  article.publishedAt.split('T').first,
                  style: textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              article.description ?? 'Resumo indisponível.',
              style: textTheme.bodyLarge?.copyWith(height: 1.4),
            ),
            const SizedBox(height: 32),
            if (article.url.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.menu_book_rounded),
                  label: const Text('Ler notícia completa'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: textTheme.titleMedium,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ArticleWebViewPage(
                          title: article.title,
                          url: article.url,
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

