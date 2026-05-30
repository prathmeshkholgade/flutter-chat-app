import 'package:intl/intl.dart';

class Helpers {
  static String formatChatTime(DateTime? dateTime) {
    if (dateTime == null) return "";

    return DateFormat("hh:mm a").format(dateTime).toLowerCase();
  }
}
