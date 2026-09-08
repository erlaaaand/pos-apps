import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/export/report_table.dart';
import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/analytics_providers.dart';
import 'export_buttons_row.dart';

class MenuPerformanceTab extends ConsumerWidget {
  const MenuPerformanceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performanceAsync = ref.watch(menuPerformanceProvider);

    return AsyncValueView(
      value: performanceAsync,
      onRetry: () => ref.invalidate(menuPerformanceProvider),
      data: (context, rows) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExportButtonsRow(
                fileNameWithoutExtension: 'performa-menu',
                tableBuilder: () => ReportTable(
                  headers: const [
                    'Produk',
                    'Status',
                    'Selesai',
                    'Dibatalkan',
                    'Qty Terjual',
                    'Pendapatan (Rp)',
                    'HPP (Rp)',
                    'Margin (Rp)',
                  ],
                  rows: rows
                      .map(
                        (row) => [
                          row.productName,
                          row.isActive ? 'Aktif' : 'Nonaktif',
                          row.completedCount,
                          row.cancelledCount,
                          row.totalQuantitySold,
                          row.totalRevenueRupiah,
                          row.totalHppRupiah,
                          row.marginRupiah,
                        ],
                      )
                      .toList(),
                ),
              ),
              if (rows.isEmpty)
                const Expanded(
                  child: EmptyState(message: 'Belum ada produk.'),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      return Card(
                        child: ListTile(
                          title: Text(row.productName),
                          subtitle: Text(
                            '${row.isActive ? "Aktif" : "Nonaktif"} · '
                            '${row.completedCount} selesai · '
                            '${row.cancelledCount} dibatalkan',
                          ),
                          trailing: Text(
                            'Margin ${RupiahFormatter.format(row.marginRupiah)}',
                          ),
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
