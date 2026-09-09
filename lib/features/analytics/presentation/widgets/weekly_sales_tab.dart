import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/export/report_table.dart';
import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/analytics_providers.dart';
import '../../domain/weekly_product_sales.dart';
import 'export_buttons_row.dart';

class WeeklySalesTab extends ConsumerWidget {
  const WeeklySalesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(weeklySalesTrendProvider);
    final dateFormat = DateFormat('d MMM', 'id_ID');

    return AsyncValueView(
      value: trendAsync,
      onRetry: () => ref.invalidate(weeklySalesTrendProvider),
      data: (context, rows) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExportButtonsRow(
                fileNameWithoutExtension: 'tren-penjualan-mingguan',
                tableBuilder: () => _toTable(rows, dateFormat),
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
                          title: Text(row.productName),
                          subtitle: Text(
                            'Minggu ${dateFormat.format(row.weekStart)} · '
                            '${row.quantitySold} terjual',
                          ),
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

  ReportTable _toTable(List<WeeklyProductSales> rows, DateFormat dateFormat) {
    return ReportTable(
      headers: const [
        'Minggu Mulai',
        'Produk',
        'Qty Terjual',
        'Pendapatan (Rp)',
      ],
      rows: rows
          .map(
            (row) => [
              dateFormat.format(row.weekStart),
              row.productName,
              row.quantitySold,
              row.revenueRupiah,
            ],
          )
          .toList(),
    );
  }
}
