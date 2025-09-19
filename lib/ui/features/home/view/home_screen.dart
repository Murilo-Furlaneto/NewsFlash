import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:news_flash/ui/features/home/view/news_details_page.dart';
import 'package:news_flash/ui/features/home/view/widgets/home/carrossel/category_widget.dart';
import 'package:news_flash/ui/features/home/view_model/cubit/news/news_cubit.dart';
import 'package:news_flash/ui/features/home/view_model/cubit/news/news_state.dart';
import 'package:news_flash/utils/helper/date_helper.dart';
import 'package:news_flash/utils/helper/string_helper.dart';
import 'package:news_flash/domain/models/article_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _cubit = GetIt.instance<NewsCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadNews();
    });
  }

  void _onSearchSubmitted(String query) async {
    try {
      await _cubit.searchNews(query, _cubit.currentPage);
    } finally {}
  }

  void _onSearchClear() {
    _searchController.clear();
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
          headerSliverBuilder: (context, innerBoxScrolled) => [_buildAppBar()],
          body: _buildBody(),
        ),
      ),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    return BlocBuilder(
      bloc: _cubit,
      builder: (context, state) {
        if (state is LoadingNewsState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorNewsState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erro: ${state.errorMessage}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _cubit.refresh(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryWidget(cubit: _cubit),
                const SizedBox(height: 16),
                _buildSectionHeader(),
                const SizedBox(height: 10),
                Expanded(child: _buildNewsList(_cubit.newsCategory)),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
              ],
            ),
          );
        }
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
      return const Center(child: Text('Nenhuma notícia encontrada.'));
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _cubit.nextPage();
      }
    });

    return ListView.separated(
      controller: _scrollController,
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailsPage(
                article: articles[index],
                cubit: _cubit,
              ),
            ),
          );
        },
        child: _buildNewsCard(articles[index]),
      ),
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
}