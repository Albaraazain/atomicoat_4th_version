import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  static String formatDateTimeRange(DateTime start, DateTime end) {
    final startStr = formatDateTime(start);
    final endStr = formatDateTime(end);
    return '$startStr - $endStr';
  }

  static String getWeekdayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}