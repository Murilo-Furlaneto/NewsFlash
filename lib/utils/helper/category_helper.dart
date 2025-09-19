import 'package:news_flash/utils/enum/news_category.dart';

class CategoryHelper {
  String convertCategoryName(NewsCategory category) {
   return category.toString().split('.').last;
  }
}
