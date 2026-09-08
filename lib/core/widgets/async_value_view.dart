import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_state.dart';

/// Renders an [AsyncValue] with consistent loading/error/data handling so
/// screens don't hand-roll `.when(...)` with ad hoc error UI each time.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (value) => data(context, value),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          ErrorState(message: error.toString(), onRetry: onRetry),
    );
  }
}
