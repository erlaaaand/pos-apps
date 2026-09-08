/// Strips the time-of-day component so date-only columns (like
/// [DailyClosings.date]) compare correctly regardless of when during the day
/// a row was written.
DateTime dateOnly(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}
