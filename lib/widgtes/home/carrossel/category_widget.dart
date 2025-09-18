import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_flash/cubit/news/news_cubit.dart';
import 'package:news_flash/data/enum/news_category.dart';
import 'package:news_flash/widgtes/home/carrossel/category_button.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.cubit});

  final NewsCubit cubit;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
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
                final isSelected = category == state;

                return CategoryButton(
                  category: category,
                  isSelected: isSelected,
                  onTap: () => cubit.changeCategory(category),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
