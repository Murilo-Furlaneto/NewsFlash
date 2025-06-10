class StringHelper {
  static String formatNewsSource(String? name) {
    name = name!.replaceAll(RegExp(r'[^a-zA-Z]'), ' ');

    name = name.trim().replaceAll(RegExp(r'\s+'), ' ');

    return name
        .split(" ")
        .map((word) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(" ");
  }
}
