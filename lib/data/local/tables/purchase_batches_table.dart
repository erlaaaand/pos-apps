import 'package:drift/drift.dart';

/// Satu kali transaksi belanja (new_flow.md A.2 "pembelian borongan/paket").
///
/// Satu batch bisa mencakup beberapa bahan sekaligus dengan satu harga total
/// — mis. kolang-kaling + pandan + jahe dibeli bareng Rp20.000. Biaya lalu
/// dibagi ke tiap bahan (default rata, bisa diatur manual per bahan) dan tiap
/// bagian tetap masuk sebagai satu baris [IngredientPurchases] tersendiri,
/// sehingga rata-rata tertimbang per bahan tetap jalan tanpa perubahan.
///
/// Batch juga jadi wadah "pencatatan pembelian harian" yang diminta update.md:
/// satu kali belanja = satu batch, walaupun isinya cuma satu bahan.
@DataClassName('PurchaseBatch')
class PurchaseBatches extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Tanggal belanja, diisi pemilik (boleh mundur, tidak dipaksa hari ini).
  DateTimeColumn get purchasedAt => dateTime()();

  TextColumn get storeName => text().nullable()();

  /// Total yang benar-benar dibayar untuk seluruh isi batch, dalam Rupiah
  /// bulat. Jumlah alokasi semua baris pembelian di batch ini harus persis
  /// sama dengan angka ini.
  IntColumn get totalPriceRupiah => integer()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
