import 'package:drift/drift.dart';

/// Setelan aplikasi berbentuk key-value.
///
/// Sengaja dibuat generik, bukan satu kolom per setelan: preferensi tampilan
/// bertambah seiring waktu, dan tiap penambahan kolom berarti satu migrasi
/// skema lagi. Dengan bentuk ini, setelan baru cukup menambah satu baris.
///
/// Hanya untuk preferensi yang boleh hilang tanpa merusak apa pun — data
/// bisnis tetap wajib punya tabelnya sendiri yang bertipe jelas.
@DataClassName('AppSetting')
class AppSettings extends Table {
  /// Kunci setelan, misal `theme_mode`. Lihat `AppSettingKeys`.
  TextColumn get key => text()();

  /// Nilai dalam bentuk teks. Pemanggil yang menafsirkannya.
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
