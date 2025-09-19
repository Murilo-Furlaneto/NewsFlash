import 'package:flutter/material.dart';
import 'package:news_flash/utils/enum/news_category.dart';

class CategoryButton extends StatelessWidget {
  final NewsCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    required this.category,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        category.name[0].toUpperCase() + category.name.substring(1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 97,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[200],
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              displayName,
              maxLines: 1,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.blue : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
