import 'package:flutter/material.dart';
import 'package:news_flash/models/article_model.dart';

class NewsDetailsPage extends StatefulWidget {
  const NewsDetailsPage({super.key});

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage>
    with SingleTickerProviderStateMixin {
  late Article article;
  bool isFavorited = false;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
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
    });
    // Aqui você pode implementar a lógica para salvar o favorito em banco ou estado global
  }

  @override
  Widget build(BuildContext context) {
    article = ModalRoute.of(context)?.settings.arguments as Article;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        title: Text(
          article.source.name,
          style: textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
        ),
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
                if (article.author != null)
                  Expanded(
                    child: Text(
                      'Por ${article.author}',
                      style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                Text(
                  article.publishedAt.split('T').first,
                  style: textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              article.content ?? article.description ?? 'Conteúdo indisponível.',
              style: textTheme.bodyLarge?.copyWith(height: 1.4),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
