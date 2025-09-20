import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_flash/ui/features/home/view/news_details_page.dart';
import 'package:news_flash/ui/features/home/view_model/cubit/news/news_cubit.dart';
import 'package:news_flash/ui/features/home/view_model/cubit/news/news_state.dart';

class FavoriteNewsPage extends StatelessWidget {
  const FavoriteNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final newsCubit = context.read<NewsCubit>();
    newsCubit.getFavoriteNews();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is LoadingNewsState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedFavoriteNewsState) {
            if (state.favoriteNews.isEmpty) {
              return const Center(child: Text("Nenhuma notícia favorita"));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: state.favoriteNews.length,
              itemBuilder: (context, index) {
                final news = state.favoriteNews[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    title: Text(
                      news.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        newsCubit.deleteFavoriteNews(news);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsDetailsPage(
                            article: news,
                            cubit: newsCubit,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is ErrorNewsState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const Center(child: Text("Nenhuma notícia favorita"));
        },
      ),
    );
  }
}
