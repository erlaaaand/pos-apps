import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/export/report_table.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/analytics_providers.dart';
import 'export_buttons_row.dart';

class BottleneckTab extends ConsumerWidget {
  const BottleneckTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottlenecksAsync = ref.watch(cancellationBottlenecksProvider);

    return AsyncValueView(
      value: bottlenecksAsync,
      onRetry: () => ref.invalidate(cancellationBottlenecksProvider),
      data: (context, rows) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExportButtonsRow(
                fileNameWithoutExtension: 'bottleneck-bahan-baku',
                tableBuilder: () => ReportTable(
                  headers: const ['Bahan Baku', 'Jumlah Pesanan Dibatalkan'],
                  rows: rows
                      .map((row) => [row.ingredientName, row.cancellationCount])
                      .toList(),
                ),
              ),
              if (rows.isEmpty)
                const Expanded(
                  child: EmptyState(
                    message:
                        'Belum ada pesanan yang dibatalkan karena bahan '
                        'baku tidak cukup.',
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      return Card(
                        child: ListTile(
                          title: Text(row.ingredientName),
                          trailing: Text('${row.cancellationCount}×'),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
