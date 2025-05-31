import 'package:flutter/material.dart';
import 'package:news_flash/data/enum/news_category.dart';
import 'package:news_flash/provider/news_provider.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Selector<NewsProvider, NewsCategory>(
      selector: (context, newsProvider) => newsProvider.currentCategory,
      builder: (context, category, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: NewsCategory.values.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final currentCategory = NewsCategory.values[index];
                final categoryName = currentCategory.name;
                final displayName =
                    categoryName[0].toUpperCase() + categoryName.substring(1);
                final isSelected = currentCategory == category;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      context.read<NewsProvider>().fetchNews(currentCategory);
                    },
                    child: Container(
                      width: 97,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: Colors.grey[200],
                      ),
                      child: Center(
                        child: Text(
                          displayName,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.blue : Colors.black,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
