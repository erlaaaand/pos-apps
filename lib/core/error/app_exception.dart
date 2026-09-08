/// Marker for exceptions that already carry a message safe to show directly
/// to the user (Indonesian, no stack traces/technical detail). Domain
/// exceptions across features implement this instead of leaking raw
/// exception text into the UI.
abstract interface class AppException implements Exception {
  String get message;
}

/// Maps any caught error to UI-safe text: the exception's own [message] if
/// it's an [AppException], otherwise a generic fallback so raw technical
/// errors (SQLite errors, etc.) never reach the screen directly.
String friendlyErrorMessage(Object error) {
  if (error is AppException) return error.message;
  return 'Terjadi kesalahan tak terduga. Coba lagi.';
}
