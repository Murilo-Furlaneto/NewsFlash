import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_flash/ui/features/home/view/widgets/home/carrossel/category_button.dart';
import 'package:news_flash/ui/features/home/view_model/cubit/news/news_cubit.dart';
import 'package:news_flash/utils/enum/news_category.dart';

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
