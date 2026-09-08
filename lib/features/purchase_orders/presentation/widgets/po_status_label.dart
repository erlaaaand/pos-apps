import 'package:flutter/material.dart';

import '../../../../data/local/app_database.dart';

extension PoStatusLabel on PoStatus {
  String get label => switch (this) {
    PoStatus.draft => 'Draft',
    PoStatus.open => 'Buka',
    PoStatus.closed => 'Tutup',
    PoStatus.cooked => 'Selesai Masak',
  };

  Color color(BuildContext context) => switch (this) {
    PoStatus.draft => Colors.grey,
    PoStatus.open => Colors.green,
    PoStatus.closed => Colors.orange,
    PoStatus.cooked => Colors.blue,
  };
}
