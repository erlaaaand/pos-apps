import 'package:flutter/material.dart';

import '../../../../data/local/app_database.dart';

extension OrderStatusLabel on OrderStatus {
  String get label => switch (this) {
    OrderStatus.waiting => 'Menunggu',
    OrderStatus.readyForPickup => 'Siap Diambil',
    OrderStatus.completed => 'Selesai',
    OrderStatus.cancelled => 'Dibatalkan',
    OrderStatus.wasted => 'Waste',
  };

  Color color(BuildContext context) => switch (this) {
    OrderStatus.waiting => Colors.grey,
    OrderStatus.readyForPickup => Colors.blue,
    OrderStatus.completed => Colors.green,
    OrderStatus.cancelled => Colors.red,
    OrderStatus.wasted => Colors.deepOrange,
  };
}
