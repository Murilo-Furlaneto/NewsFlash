import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:news_flash/data/helper/date_helper.dart';
import 'package:news_flash/data/helper/string_helper.dart';
import 'package:news_flash/models/article_model.dart';
import 'package:news_flash/provider/news/news_provider.dart';
import 'package:news_flash/view/news/favorite_news_page.dart';
import 'package:news_flash/view/news/news_details_page.dart';
import 'package:news_flash/widgtes/home/carrossel/category_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _selectedBottomNavIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final _newsProvider = GetIt.instance<NewsProvider>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _newsProvider.loadNews();
    });
  }


  void _onSearchSubmitted(String query) async {
  setState(() {
    _isSearching = true;
  });

  try {
    await _newsProvider.searchNews(query, _newsProvider.currentPage.value);
  } finally {
    if (mounted) { 
      setState(() {
        _isSearching = false;
      });
    }
  }
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
      if(!mounted){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      }
      break;
    case 1:
      _showFeatureComingSoon('Explore');
      break;
    case 2:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoriteNewsPage(newsProvider: _newsProvider),
        ),
      ).then((_) {
        setState(() {
          _selectedBottomNavIndex = 0;
        });
      });
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

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _newsProvider.nextPage();
      }
    });

    return ListView.separated(
      controller: _scrollController,
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsPage(article: articles[index], newsProvider: _newsProvider,)));
        },
        child: _buildNewsCard(articles[index])),
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