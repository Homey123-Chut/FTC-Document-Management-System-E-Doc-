import 'package:intl/intl.dart';

class DateFormatter {

  static String formatPassExpiry(DateTime date) => DateFormat('d / MMMM / yyyy').format(date);

  static DateTime? parseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  static bool isFutureDate(String? value) {
    final inputDate = parseDate(value);
    if (inputDate == null) {
      return false;
    }
    final now = DateTime.now();
    final todayAtMidnight = DateTime(now.year, now.month, now.day);

    return inputDate.isAfter(todayAtMidnight);
    
    } 
  }
