import 'package:intl/intl.dart';

DateTime? dateFromString(
    String value, {
      String format = 'dd/MM/yyyy HH:mm',
    }) {
  try {
    return DateFormat(format).parse(value);
  } catch (e) {
    return null;
  }
}

String stringFromDate(
    DateTime value, {
      String format = 'dd/MM/yyyy HH:mm',
      String? locale,
    }) {
  try {
    return DateFormat(format, locale).format(value);
  } catch (e) {
    return '';
  }
}

String stringDateFromString(
    String value, {
      String fromFormat = 'dd/MM/yyyy HH:mm',
      String toFormat = 'dd/MM/yyyy HH:mm',
      String? locale,
    }) {
  final date = dateFromString(value, format: fromFormat);
  if (date != null) return stringFromDate(date, locale: locale);
  return value;
}

String? dayOfWeekFromString(
    String value, {
      String fromFormat = 'dd/MM/yyyy HH:mm',
      String toFormat = 'EEEE',
      String? locale,
    }) {
  final date = dateFromString(value, format: fromFormat);
  if (date != null) return DateFormat(toFormat, locale).format(date);
  return null;
}
