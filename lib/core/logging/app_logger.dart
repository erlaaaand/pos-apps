import 'dart:developer' as developer;

/// Minimal logging seam so failures that are intentionally not surfaced to
/// the user (e.g. a best-effort background action) still leave a trace,
/// instead of a bare `catch (_) {}`. Thin wrapper around `dart:developer`'s
/// structured log — swap the implementation here if the project later needs
/// file/remote logging, without touching call sites.
abstract final class AppLogger {
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'dapur_kelaris',
      level: 1000, // SEVERE
      error: error,
      stackTrace: stackTrace,
    );
  }
}
