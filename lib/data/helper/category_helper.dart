import 'package:news_flash/data/enum/news_category.dart';

class CategoryHelper {
  String convertCategoryName(NewsCategory category) {
   return category.toString().split('.').last;
  }
}
