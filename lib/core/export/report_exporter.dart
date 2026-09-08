import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'report_table.dart';

/// Turns a [ReportTable] into a CSV or XLSX file and opens the OS share
/// sheet for it (Bagian C: "export csv/xlsx untuk seluruh laporan").
abstract final class ReportExporter {
  static String toCsv(ReportTable table) {
    return csv.encode([table.headers, ...table.rows]);
  }

  static List<int> toXlsx(ReportTable table) {
    final workbook = Excel.createExcel();
    final sheet = workbook['Sheet1'];
    sheet.insertRowIterables(
      table.headers.map((header) => TextCellValue(header)).toList(),
      0,
    );
    for (var i = 0; i < table.rows.length; i++) {
      sheet.insertRowIterables(
        table.rows[i].map(_toCellValue).toList(),
        i + 1,
      );
    }
    return workbook.save() ?? const [];
  }

  static CellValue _toCellValue(Object? value) {
    return switch (value) {
      null => TextCellValue(''),
      int value => IntCellValue(value),
      double value => DoubleCellValue(value),
      _ => TextCellValue(value.toString()),
    };
  }

  /// Writes [table] to a temp file and opens the share sheet so the owner
  /// can send it to Drive, WhatsApp, email, etc.
  static Future<void> share({
    required ReportTable table,
    required String fileNameWithoutExtension,
    required ExportFormat format,
  }) async {
    final directory = await getTemporaryDirectory();
    final extension = format == ExportFormat.csv ? 'csv' : 'xlsx';
    final file = File('${directory.path}/$fileNameWithoutExtension.$extension');

    if (format == ExportFormat.csv) {
      await file.writeAsString(toCsv(table));
    } else {
      await file.writeAsBytes(toXlsx(table));
    }

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)]),
    );
  }
}
