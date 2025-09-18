import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:news_flash/cubit/news/news_cubit.dart';
import 'package:news_flash/cubit/news/news_state.dart';
import 'package:news_flash/data/getIt/init_get_it.dart';
import 'package:news_flash/models/article_model.dart';
import 'package:news_flash/view/news/news_details_page.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _cubit = GetIt.instance<NewsCubit>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit.loadTopHeadlines();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _cubit.nextTopHeadlinesPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildTopHeadlines()),
        ],
      ),
    );
  }

  Widget _buildTopHeadlines() {
    return BlocBuilder<NewsCubit, NewsState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is LoadingNewsState && _cubit.topHeadlines.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorNewsState) {
          return Center(child: Text(state.errorMessage));
        } else if (_cubit.topHeadlines.isNotEmpty) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: _cubit.topHeadlines.length + 1,
            itemBuilder: (context, index) {
              if (index < _cubit.topHeadlines.length) {
                final article = _cubit.topHeadlines[index];
                return TopHeadlineCard(article: article);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class TopHeadlineCard extends StatelessWidget {
  const TopHeadlineCard({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsPage(article: article, cubit: getIt<NewsCubit>())));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Image.network(
                  article.urlToImage ?? 'https://via.placeholder.com/300x150?text=No+Image',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
