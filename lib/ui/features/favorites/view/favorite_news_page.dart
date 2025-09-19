import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_flash/ui/features/home/view/news_details_page.dart';
import 'package:news_flash/ui/features/home/view_model/cubit/news/news_cubit.dart';
import 'package:news_flash/ui/features/home/view_model/cubit/news/news_state.dart';

class FavoriteNewsPage extends StatefulWidget {
  const FavoriteNewsPage({super.key, required this.cubit});

  final NewsCubit cubit;

  @override
  State<FavoriteNewsPage> createState() => _FavoriteNewsPageState();
}

class _FavoriteNewsPageState extends State<FavoriteNewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: BlocBuilder(
        bloc: widget.cubit,
        builder: (context, state) {
          if (state is LoadingNewsState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadedNewsState) {
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final news = widget.cubit.favoriteNews[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          title: Text(
                            news.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              widget.cubit.deleteFavoriteNews(news);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => NewsDetailsPage(
                                      article: news,
                                      cubit: widget.cubit,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }, childCount: widget.cubit.favoriteNews.length),
                ),
              ],
            );
          } else if (state is ErrorNewsState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Center(
              child: Text("Nenhuma notícia favorita"),
            );
          }
        },
      ),
    );
  }
}
