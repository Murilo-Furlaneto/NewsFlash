class DateHelper {
 static String formatPublicationTimeDifference(String date) {
    DateTime dateObject = DateTime.parse(date);
    DateTime now = DateTime.now();

    Duration difference = now.difference(dateObject);

    String differenceFormatter = "${difference.inHours} hours";

    return differenceFormatter;
  }
}
