import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:news_flash/data/enum/news_category.dart';
import 'package:news_flash/data/getIt/init_get_it.dart';
import 'package:news_flash/data/repository/news_repository.dart';
import 'package:news_flash/models/article_model.dart';
import 'package:news_flash/models/news_response_model.dart';
import 'package:news_flash/provider/news_provider.dart';
import 'package:news_flash/widgtes/home/carrossel/carrossel_widget.dart';
import 'package:news_flash/widgtes/home/carrossel/category_widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _currentPage = 0;
  final _newsProvider = getIt<NewsProvider>();

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    // Implement search functionality here
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _newsProvider.fetchNews(NewsCategory.general);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxScrolled) => [
                SliverAppBar(
                  title: const Text(
                    'Notícias',
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
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar notícias...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon:
                              _searchController.text.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _isSearching = false;
                                      });
                                    },
                                  )
                                  : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey[200]
                                  : Colors.grey[800],
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                        ),
                        onSubmitted: _performSearch,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                  ),
                ),
              ],
          body: Consumer<NewsProvider>(
            builder: (BuildContext context, NewsProvider value, Widget? child) {
              return value.newsCategory.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CategoryWidget(),
                        const SizedBox(height: 8),
                        const SizedBox(height: 10),
                        const Text(
                          "Últimas notícias",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: ListView.builder(
                        
                            itemCount: value.newsCategory.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        Colors.grey[200], // mudar para white,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomLeft: Radius.circular(25),
                                          ),
                                          child: Image.network(
                                            'https://agenciapnz.com/wp-content/uploads/Logo-Google-G.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              value
                                                  .newsCategory[index]
                                                  .category,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Text(
                                              value
                                                  .newsCategory[index]
                                                  .description,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              value.newsCategory[index].id,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 20),
                          ),
                        ),
                      ],
                    ),
                  );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Salvos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
          // Adicione lógica de navegação conforme necessário
        },
      ),
    );
  }
}
