import 'package:flutter/material.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/export/report_exporter.dart';
import '../../../../core/export/report_table.dart';
import '../../../../core/theme/app_spacing.dart';

/// "Export CSV" / "Export XLSX" actions shared by every report tab.
class ExportButtonsRow extends StatelessWidget {
  const ExportButtonsRow({
    required this.fileNameWithoutExtension,
    required this.tableBuilder,
    super.key,
  });

  final String fileNameWithoutExtension;
  final ReportTable Function() tableBuilder;

  Future<void> _export(BuildContext context, ExportFormat format) async {
    try {
      await ReportExporter.share(
        table: tableBuilder(),
        fileNameWithoutExtension: fileNameWithoutExtension,
        format: format,
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () => _export(context, ExportFormat.csv),
            icon: const Icon(Icons.description_outlined),
            label: const Text('CSV'),
          ),
          const SizedBox(width: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => _export(context, ExportFormat.xlsx),
            icon: const Icon(Icons.grid_on_outlined),
            label: const Text('XLSX'),
          ),
        ],
      ),
    );
  }
}
