# Business Management

Aplikasi manajemen inventori & keuangan offline untuk bisnis PO (pre-order)
harian via WhatsApp — dibangun sesuai spesifikasi di
[`lib/base_project/erp.md`](lib/base_project/erp.md).

Cakupan (lihat `erp.md` untuk detail masing-masing bagian):

- **Bagian A** — Master bahan baku, pencatatan pembelian (harga modal
  rata-rata tertimbang otomatis), master produk & resep (HPP otomatis,
  resep tidak pernah dihapus).
- **Bagian B** — Siklus PO harian: buka/tutup PO, pesanan masuk, produksi
  dengan penanganan bahan kurang (batal/masak sebagian FIFO), penyelesaian
  pesanan, tutup hari & laba rugi.
- **Bagian C** — Laporan: tren penjualan, performa slot PO, performa menu,
  bottleneck bahan baku, tren harga beli — semua bisa diekspor CSV/XLSX.
- **Bagian D** — Backup (`.db` mentah + dump `.sql` opsional) & restore,
  otomatis ter-trigger saat tutup hari.

## Arsitektur

Feature-first, per modul: `domain` (model/exception) → `data` (repository +
implementasi Drift) → `application` (Riverpod provider) → `presentation`
(layar/widget). Database: SQLite via [Drift](https://drift.simonbinder.eu),
skema lengkap sejak awal (lihat `lib/data/local/`) sesuai instruksi di
`erp.md` supaya fase-fase berikutnya tidak perlu migrasi skema.

Target platform: Android.

## Menjalankan

```bash
flutter pub get
dart run build_runner build   # generate kode Drift (app_database.g.dart)
flutter run
```

## Test

```bash
flutter test
```
