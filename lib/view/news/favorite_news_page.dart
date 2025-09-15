import 'package:flutter/material.dart';
import 'package:news_flash/provider/news/news_provider.dart';
import 'package:news_flash/view/news/news_details_page.dart';

class FavoriteNewsPage extends StatefulWidget {
  const FavoriteNewsPage({super.key, required this.newsProvider});

  final NewsProvider newsProvider;

  @override
  State<FavoriteNewsPage> createState() => _FavoriteNewsPageState();
}

class _FavoriteNewsPageState extends State<FavoriteNewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: ValueListenableBuilder(
        valueListenable: widget.newsProvider.favoriteNews,
        builder: (context, favoriteNewsList, _) {
          if (favoriteNewsList.isEmpty) {
            return const Center(child: Text("Nenhuma notícia favorita"));
          }

          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final news = favoriteNewsList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: Text(
                            news.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: (){
                              widget.newsProvider.deleteFavoriteNews(news);
                            } ,
                          ),
                          onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsPage(article:news, newsProvider: widget.newsProvider,)));
                          },
                        ),
                      ),
                    );
                  },
                  childCount: favoriteNewsList.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}