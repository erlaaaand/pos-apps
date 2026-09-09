import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/export/report_table.dart';
import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/analytics_providers.dart';
import 'export_buttons_row.dart';

class PoSlotPerformanceTab extends ConsumerWidget {
  const PoSlotPerformanceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performanceAsync = ref.watch(poSlotPerformanceProvider);

    return AsyncValueView(
      value: performanceAsync,
      onRetry: () => ref.invalidate(poSlotPerformanceProvider),
      data: (context, rows) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExportButtonsRow(
                fileNameWithoutExtension: 'performa-slot-po',
                tableBuilder: () => ReportTable(
                  headers: const [
                    'Slot PO',
                    'Produk',
                    'Qty Terjual',
                    'Pendapatan (Rp)',
                  ],
                  rows: rows
                      .map(
                        (row) => [
                          row.slotLabel,
                          row.productName,
                          row.quantitySold,
                          row.revenueRupiah,
                        ],
                      )
                      .toList(),
                ),
              ),
              if (rows.isEmpty)
                const Expanded(
                  child: EmptyState(message: 'Belum ada penjualan selesai.'),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      return Card(
                        child: ListTile(
                          title: Text('${row.slotLabel} · ${row.productName}'),
                          subtitle: Text('${row.quantitySold} terjual'),
                          trailing: Text(
                            RupiahFormatter.format(row.revenueRupiah),
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
