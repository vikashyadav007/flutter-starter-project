// Package imports:
import 'package:intl/intl.dart';

String get hourAndMinuteFormat => 'HH:mm a';

String get monthDateYearFormat => 'MMM dd, yyyy';

String formatDate(
    {required String dateTimeString, String dateFormat = 'yyyy-MM-dd'}) {
  DateTime dateTime = DateTime.parse(dateTimeString).toLocal();

  return DateFormat(dateFormat).format(dateTime);
}

bool isSameDay(DateTime? date1, DateTime? date2) {
  return date1 != null &&
      date2 != null &&
      date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

bool isToday(DateTime? date) {
  final now = DateTime.now();
  return date != null &&
      date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

bool isYesterday(DateTime? date) {
  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  return date != null &&
      date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day;
}

bool isSameMinute(DateTime? time1, DateTime? time2) =>
    time1 != null &&
    time2 != null &&
    time1.year == time2.year &&
    time1.month == time2.month &&
    time1.day == time2.day &&
    time1.hour == time2.hour &&
    time1.minute == time2.minute;
