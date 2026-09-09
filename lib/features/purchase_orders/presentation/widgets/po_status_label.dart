import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/local/app_database.dart';

extension PoStatusLabel on PoStatus {
  String get label => switch (this) {
    PoStatus.draft => 'Draft',
    PoStatus.open => 'Buka',
    PoStatus.closed => 'Tutup',
    PoStatus.cooked => 'Selesai Masak',
  };

  /// Semantic mapping: draft = nothing happening yet, open = actively taking
  /// orders, closed = waiting on the owner to cook, cooked = done, informational.
  Color color(BuildContext context) => switch (this) {
    PoStatus.draft => AppColors.neutral,
    PoStatus.open => AppColors.success,
    PoStatus.closed => AppColors.warning,
    PoStatus.cooked => AppColors.info,
  };
}
