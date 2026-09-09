import 'dart:io';

import 'package:excel/excel.dart';

void main() async {
  final excel = Excel.createExcel();
  final sheetName = excel.sheets.keys.first;
  final sheet = excel[sheetName];

  // Header
  sheet.appendRow([
    TextCellValue('Nama Bahan'),
    TextCellValue('Satuan'),
    TextCellValue('Kategori'),
  ]);

  // Data 24 Bahan Baku
  final items = [
    ['Durian', 'gram', 'Buah-buahan'],
    ['Semangka', 'gram', 'Buah-buahan'],
    ['Melon', 'gram', 'Buah-buahan'],
    ['Nangka', 'gram', 'Buah-buahan'],
    ['Agar powder', 'sachet', 'Bahan Dapur'],
    ['Nutrijel', 'sachet', 'Bahan Dapur'],
    ['Susu Evorasi', 'gram', 'Bahan Dapur'],
    ['Susu Cream', 'gram', 'Bahan Dapur'],
    ['Mangga', 'gram', 'Buah-buahan'],
    ['Es batu', 'gram', 'Bahan Dapur'],
    ['Anggur', 'gram', 'Buah-buahan'],
    ['Beras ketan', 'gram', 'Bahan Dapur'],
    ['Santan', 'ml', 'Bahan Dapur'],
    ['Gula', 'gram', 'Bahan Dapur'],
    ['Kelapa parut', 'gram', 'Bahan Dapur'],
    ['Keju', 'gram', 'Bahan Dapur'],
    ['Kolang-kaling (Paket Pelengkap)', 'pemakaian', 'Paket Pelengkap'],
    ['Pandan (Paket Pelengkap)', 'pemakaian', 'Paket Pelengkap'],
    ['Jahe (Paket Pelengkap)', 'pemakaian', 'Paket Pelengkap'],
    ['Air', 'pemakaian', 'Paket Pelengkap'],
    ['Cup 300g', 'pcs', 'Kemasan'],
    ['Sendok 300g', 'pcs', 'Kemasan'],
    ['Cup 450g', 'pcs', 'Kemasan'],
    ['Sendok 450g', 'pcs', 'Kemasan'],
  ];

  for (final row in items) {
    sheet.appendRow([
      TextCellValue(row[0]),
      TextCellValue(row[1]),
      TextCellValue(row[2]),
    ]);
  }

  final fileBytes = excel.save();
  if (fileBytes != null) {
    final outFile = File('import_bahan_baku.xlsx');
    await outFile.writeAsBytes(fileBytes);
    print('File Excel berhasil dibuat: ${outFile.absolute.path}');
  } else {
    print('Gagal membuat byte Excel.');
  }
}
