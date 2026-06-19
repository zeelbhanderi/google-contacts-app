import 'package:intl/intl.dart';

class DateUtilsX {
  DateUtilsX._();

  static DateTime now() {
    return DateTime.now();
  }

  static String? localToUtc(DateTime? local) {
    if (local == null) return null;
    return local.toUtc().toIso8601String();
  }

  static DateTime? utcToLocal(String? utc) {
    if (utc == null || utc.trim().isEmpty) return null;

    try {
      return DateTime.parse(utc).toLocal();
    } catch (_) {
      return null;
    }
  }

  static DateTime? normalizeBirthday(DateTime? local) {
    if (local == null) return null;
    final localDate = local.toLocal();
    return DateTime(localDate.year, localDate.month, localDate.day);
  }

  static String? birthdayToStorage(DateTime? local) {
    return localToUtc(normalizeBirthday(local));
  }

  static DateTime? birthdayFromStorage(String? utc) {
    return normalizeBirthday(utcToLocal(utc));
  }

  static String formatDate(DateTime? date, {String pattern = 'dd-MM-yyyy'}) {
    if (date == null) return '';
    return DateFormat(pattern).format(date);
  }

  static String formatBirthday(DateTime? birthday) {
    final local = normalizeBirthday(birthday);
    if (local == null) return '';
    return DateFormat('dd/MM/yyyy').format(local);
  }
}
