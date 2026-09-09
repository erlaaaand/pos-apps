import '../../../data/local/app_database.dart';

/// Kelompok satuan, dipakai untuk mengelompokkan pilihan di dropdown supaya
/// 18 satuan tidak tampil sebagai satu daftar panjang.
enum IngredientUnitGroup { beratVolume, takaranDapur, satuanHitung, kemasan }

/// Display labels for [IngredientUnit] — kept in one place so every screen
/// shows the same wording.
extension IngredientUnitLabel on IngredientUnit {
  String get label => switch (this) {
    IngredientUnit.gram => 'Gram',
    IngredientUnit.kilogram => 'Kilogram',
    IngredientUnit.pcs => 'Pcs',
    IngredientUnit.milliliter => 'Mililiter',
    IngredientUnit.liter => 'Liter',
    IngredientUnit.ons => 'Ons',
    IngredientUnit.sendokTeh => 'Sendok Teh',
    IngredientUnit.sendokMakan => 'Sendok Makan',
    IngredientUnit.gelas => 'Gelas',
    IngredientUnit.buah => 'Buah',
    IngredientUnit.butir => 'Butir',
    IngredientUnit.lembar => 'Lembar',
    IngredientUnit.ikat => 'Ikat',
    IngredientUnit.bungkus => 'Bungkus',
    IngredientUnit.sachet => 'Sachet',
    IngredientUnit.botol => 'Botol',
    IngredientUnit.kaleng => 'Kaleng',
    IngredientUnit.pack => 'Pack',
  };

  String get shortLabel => switch (this) {
    IngredientUnit.gram => 'gram',
    IngredientUnit.kilogram => 'kg',
    IngredientUnit.pcs => 'pcs',
    IngredientUnit.milliliter => 'ml',
    IngredientUnit.liter => 'liter',
    IngredientUnit.ons => 'ons',
    IngredientUnit.sendokTeh => 'sdt',
    IngredientUnit.sendokMakan => 'sdm',
    IngredientUnit.gelas => 'gelas',
    IngredientUnit.buah => 'buah',
    IngredientUnit.butir => 'butir',
    IngredientUnit.lembar => 'lembar',
    IngredientUnit.ikat => 'ikat',
    IngredientUnit.bungkus => 'bungkus',
    IngredientUnit.sachet => 'sachet',
    IngredientUnit.botol => 'botol',
    IngredientUnit.kaleng => 'kaleng',
    IngredientUnit.pack => 'pack',
  };

  IngredientUnitGroup get group => switch (this) {
    IngredientUnit.gram ||
    IngredientUnit.kilogram ||
    IngredientUnit.ons ||
    IngredientUnit.milliliter ||
    IngredientUnit.liter => IngredientUnitGroup.beratVolume,
    IngredientUnit.sendokTeh ||
    IngredientUnit.sendokMakan ||
    IngredientUnit.gelas => IngredientUnitGroup.takaranDapur,
    IngredientUnit.pcs ||
    IngredientUnit.buah ||
    IngredientUnit.butir ||
    IngredientUnit.lembar ||
    IngredientUnit.ikat => IngredientUnitGroup.satuanHitung,
    IngredientUnit.bungkus ||
    IngredientUnit.sachet ||
    IngredientUnit.botol ||
    IngredientUnit.kaleng ||
    IngredientUnit.pack => IngredientUnitGroup.kemasan,
  };
}

extension IngredientUnitGroupLabel on IngredientUnitGroup {
  String get label => switch (this) {
    IngredientUnitGroup.beratVolume => 'Berat & Volume',
    IngredientUnitGroup.takaranDapur => 'Takaran Dapur',
    IngredientUnitGroup.satuanHitung => 'Satuan Hitung',
    IngredientUnitGroup.kemasan => 'Kemasan',
  };

  /// Satuan milik kelompok ini, urut sesuai deklarasi enum.
  List<IngredientUnit> get units =>
      IngredientUnit.values.where((unit) => unit.group == this).toList();
}

/// Trims trailing zeros so whole quantities don't show as "2.0" or "2.50".
String formatQuantity(double quantity) {
  if (quantity == quantity.roundToDouble()) {
    return quantity.toStringAsFixed(0);
  }
  var str = quantity.toStringAsFixed(2);
  if (str.contains('.')) {
    str = str.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
  return str;
}

extension IngredientConversionFormatting on IngredientUnit {
  /// Mengembalikan nilai stok lengkap beserta konversinya (misal: gram ke kg).
  String formatStockWithConversion(double stock) {
    final base = '${formatQuantity(stock)} $shortLabel';
    switch (this) {
      case IngredientUnit.gram:
        final inKg = stock / 1000.0;
        return '$base (${formatQuantity(inKg)} kg)';
      case IngredientUnit.kilogram:
        final inGram = stock * 1000.0;
        return '$base (${formatQuantity(inGram)} gram)';
      case IngredientUnit.ons:
        final inKg = stock / 10.0;
        return '$base (${formatQuantity(inKg)} kg)';
      case IngredientUnit.milliliter:
        final inLiter = stock / 1000.0;
        return '$base (${formatQuantity(inLiter)} liter)';
      case IngredientUnit.liter:
        final inMl = stock * 1000.0;
        return '$base (${formatQuantity(inMl)} ml)';
      default:
        return base;
    }
  }

  /// Menghitung harga modal dalam basis kilogram (atau basis liter untuk cairan).
  /// Mengembalikan `null` jika satuan tidak termasuk satuan bobot/volume.
  double? costPerKg(double costPerUnit) {
    switch (this) {
      case IngredientUnit.gram:
        return costPerUnit * 1000.0;
      case IngredientUnit.kilogram:
        return costPerUnit;
      case IngredientUnit.ons:
        return costPerUnit * 10.0;
      case IngredientUnit.milliliter:
        return costPerUnit * 1000.0;
      case IngredientUnit.liter:
        return costPerUnit;
      default:
        return null;
    }
  }

  /// Label unit sekunder untuk basis per-kg atau per-liter.
  String? get secondaryUnitLabel {
    switch (this) {
      case IngredientUnit.gram:
      case IngredientUnit.ons:
        return 'kg';
      case IngredientUnit.kilogram:
        return 'gram';
      case IngredientUnit.milliliter:
        return 'liter';
      case IngredientUnit.liter:
        return 'ml';
      default:
        return null;
    }
  }

  /// Menghitung harga modal dalam unit sekunder (misal per gram jika unit kg).
  double? secondaryCost(double costPerUnit) {
    switch (this) {
      case IngredientUnit.gram:
      case IngredientUnit.ons:
        return costPerKg(costPerUnit);
      case IngredientUnit.kilogram:
        return costPerUnit / 1000.0;
      case IngredientUnit.milliliter:
        return costPerUnit * 1000.0;
      case IngredientUnit.liter:
        return costPerUnit / 1000.0;
      default:
        return null;
    }
  }
}

/// Mengonversi kuantitas dari [fromUnit] (satuan takaran kustom di resep)
/// ke [targetBaseUnit] (satuan dasar bahan baku di master).
double convertQuantityToBaseUnit(
  double quantity,
  IngredientUnit fromUnit,
  IngredientUnit targetBaseUnit,
) {
  if (fromUnit == targetBaseUnit) return quantity;

  // 1. Konversi dari fromUnit ke nilai dasar (gram / ml / pcs)
  final double inGramOrMl;
  switch (fromUnit) {
    case IngredientUnit.gram:
      inGramOrMl = quantity;
      break;
    case IngredientUnit.kilogram:
      inGramOrMl = quantity * 1000.0;
      break;
    case IngredientUnit.ons:
      inGramOrMl = quantity * 100.0;
      break;
    case IngredientUnit.milliliter:
      inGramOrMl = quantity;
      break;
    case IngredientUnit.liter:
      inGramOrMl = quantity * 1000.0;
      break;
    case IngredientUnit.sendokTeh:
      inGramOrMl = quantity * 5.0; // 1 sdt ~ 5g / 5ml
      break;
    case IngredientUnit.sendokMakan:
      inGramOrMl = quantity * 15.0; // 1 sdm ~ 15g / 15ml
      break;
    case IngredientUnit.gelas:
      inGramOrMl = quantity * 200.0; // 1 gelas ~ 200g / 200ml
      break;
    default:
      inGramOrMl = quantity;
      break;
  }

  // 2. Konversi dari nilai dasar ke targetBaseUnit
  switch (targetBaseUnit) {
    case IngredientUnit.kilogram:
      return inGramOrMl / 1000.0;
    case IngredientUnit.gram:
      return inGramOrMl;
    case IngredientUnit.ons:
      return inGramOrMl / 100.0;
    case IngredientUnit.liter:
      return inGramOrMl / 1000.0;
    case IngredientUnit.milliliter:
      return inGramOrMl;
    default:
      return quantity;
  }
}
