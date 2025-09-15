import 'package:flutter/material.dart';
import 'package:news_flash/data/enum/news_category.dart';
import 'package:news_flash/provider/news/news_provider.dart';
import 'package:news_flash/widgtes/home/carrossel/category_button.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.newsProvider});

  final NewsProvider newsProvider;

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<NewsCategory>(
      valueListenable: newsProvider.currentCategory,
      builder: (context, selectedCategory, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: NewsCategory.values.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final category = NewsCategory.values[index];
                final isSelected = category == selectedCategory;

                return CategoryButton(
                  category: category,
                  isSelected: isSelected,
                  onTap: () => newsProvider.changeCategory(category),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
