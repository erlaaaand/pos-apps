import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/export/report_table.dart';
import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/analytics_providers.dart';
import 'export_buttons_row.dart';

class IngredientPriceTrendTab extends ConsumerWidget {
  const IngredientPriceTrendTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(ingredientPriceTrendProvider);
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');

    return AsyncValueView(
      value: trendAsync,
      onRetry: () => ref.invalidate(ingredientPriceTrendProvider),
      data: (context, rows) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExportButtonsRow(
                fileNameWithoutExtension: 'tren-harga-beli-bahan-baku',
                tableBuilder: () => ReportTable(
                  headers: const [
                    'Bahan Baku',
                    'Tanggal',
                    'Harga/Satuan (Rp)',
                    'Toko',
                  ],
                  rows: rows
                      .map(
                        (row) => [
                          row.ingredientName,
                          dateFormat.format(row.purchasedAt),
                          row.pricePerUnit.round(),
                          row.storeName ?? '',
                        ],
                      )
                      .toList(),
                ),
              ),
              if (rows.isEmpty)
                const Expanded(
                  child: EmptyState(message: 'Belum ada riwayat pembelian.'),
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
                          subtitle: Text(
                            '${dateFormat.format(row.purchasedAt)}'
                            '${row.storeName != null ? ' · ${row.storeName}' : ''}',
                          ),
                          trailing: Text(
                            RupiahFormatter.format(row.pricePerUnit.round()),
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
