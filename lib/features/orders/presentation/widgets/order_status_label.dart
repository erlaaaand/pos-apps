import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/local/app_database.dart';

extension OrderStatusLabel on OrderStatus {
  String get label => switch (this) {
    OrderStatus.waiting => 'Menunggu',
    OrderStatus.readyForPickup => 'Siap Diambil',
    OrderStatus.completed => 'Selesai',
    OrderStatus.cancelled => 'Dibatalkan',
    OrderStatus.wasted => 'Waste',
  };

  /// Semantic mapping: waiting = not acted on yet, ready = informational,
  /// completed = the good outcome, cancelled = lost order, wasted = cooked but
  /// unsold, i.e. a material loss the owner should notice but not an error.
  Color color(BuildContext context) => switch (this) {
    OrderStatus.waiting => AppColors.neutral,
    OrderStatus.readyForPickup => AppColors.info,
    OrderStatus.completed => AppColors.success,
    OrderStatus.cancelled => AppColors.danger,
    OrderStatus.wasted => AppColors.warning,
  };
}
