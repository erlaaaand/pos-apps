import 'date_only.dart';

/// Monday of the week containing [date] — the grouping key for weekly
/// sales-trend reporting (Bagian C).
DateTime weekStart(DateTime date) {
  final day = dateOnly(date);
  return day.subtract(Duration(days: day.weekday - 1));
}
