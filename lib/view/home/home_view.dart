import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:news_flash/data/helper/date_helper.dart';
import 'package:news_flash/data/helper/string_helper.dart';
import 'package:news_flash/models/article_model.dart';
import 'package:news_flash/provider/news_provider.dart';
import 'package:news_flash/widgtes/home/carrossel/category_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _selectedBottomNavIndex = 0;
  
  final _newsProvider = GetIt.instance<NewsProvider>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _newsProvider.loadNews();
    });
  }


  void _onSearchSubmitted(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    // TODO: Implementar busca via provider
    // _newsProvider.searchNews(query);
  }

  void _onSearchClear() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Home - já estamos aqui
        break;
      case 1:
        _showFeatureComingSoon('Explore');
        break;
      case 2:
        _showFeatureComingSoon('Saved');
        break;
      case 3:
        _showFeatureComingSoon('Profile');
        break;
    }
  }

  void _showFeatureComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Em breve!'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            _buildAppBar(),
          ],
          body: _buildBody(),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }


  Widget _buildAppBar() {
    return SliverAppBar(
      title: const Text(
        'News',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      floating: true,
      actions: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            "N",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _buildSearchBar(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search news...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _onSearchClear,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]
              : Colors.grey[800],
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onSubmitted: _onSearchSubmitted,
        textInputAction: TextInputAction.search,
      ),
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder<bool>(
      valueListenable: _newsProvider.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ValueListenableBuilder<List<Article>>(
          valueListenable: _newsProvider.newsCategory,
          builder: (context, articles, _) {
            if (_newsProvider.errorMessage.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erro: ${_newsProvider.errorMessage}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _newsProvider.refresh(),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryWidget(newsProvider: _newsProvider),
                  const SizedBox(height: 16),
                  _buildSectionHeader(),
                  const SizedBox(height: 10),
                  Expanded(child: _buildNewsList(articles)),
                  const SizedBox(height: 10),
                  _buildPaginationControls(),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: const [
        Icon(Icons.newspaper, color: Colors.blue),
        SizedBox(width: 8),
        Text(
          "Latest News",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildNewsList(List<Article> articles) {
    if (articles.isEmpty) {
      return const Center(
        child: Text('Nenhuma notícia encontrada.'),
      );
    }

    return ListView.separated(
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildNewsCard(articles[index]),
    );
  }

  Widget _buildNewsCard(Article article) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildNewsImage(article.urlToImage),
          const SizedBox(width: 12),
          Expanded(child: _buildNewsContent(article)),
        ],
      ),
    );
  }

  Widget _buildNewsImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18),
        bottomLeft: Radius.circular(18),
      ),
      child: Image.network(
        imageUrl ?? 'https://via.placeholder.com/90x70.png?text=No+Image',
        height: 90,
        width: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          height: 90,
          width: 90,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildNewsContent(Article article) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            article.description ?? 'Description not available',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          _buildNewsMetadata(article),
        ],
      ),
    );
  }

  Widget _buildNewsMetadata(Article article) {
    return Row(
      children: [
        Icon(Icons.source, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          StringHelper.formatNewsSource(article.source.id ?? 'Unknown source'),
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          "${DateHelper.formatPublicationTimeDifference(article.publishedAt)} ago",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

 Widget _buildPaginationControls() {
  return ValueListenableBuilder<int>(
    valueListenable: _newsProvider.currentPage,
    builder: (context, currentPage, _) {
      final canGoPrev = _newsProvider.canGoPrevious;
      final canGoNext = _newsProvider.canGoNext;

      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                color: canGoPrev ? Colors.blueAccent : Colors.grey.shade400,
                onPressed: canGoPrev ? () => _newsProvider.previousPage() : null,
                tooltip: canGoPrev ? 'Página anterior' : null,
              ),
              SizedBox(width: 12),
              Text(
                'Página $currentPage',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios_rounded),
                color: canGoNext ? Colors.blueAccent : Colors.grey.shade400,
                onPressed: canGoNext ? () => _newsProvider.nextPage() : null,
                tooltip: canGoNext ? 'Próxima página' : null,
              ),
            ],
          ),
        ),
      );
    },
  );
}

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedBottomNavIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: _onBottomNavTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}