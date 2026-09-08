# Spesifikasi ERP Lengkap: Manajemen Inventori & Keuangan
### Es Teler Durian & Ketan Talam Durian — model PO via WhatsApp

## Model Bisnis Riil

Pola operasional di lapangan berbasis **PO (Pre-Order) batch**:

**Pagi** → PO 1 dibuat & dibuka, kuota diposting → pesanan masuk sampai kuota penuh/ditutup manual → seluruh pesanan dalam PO dimasak sekaligus → **siang, sore** → siklus berulang (total 4 slot: Pagi/Siang/Sore/Malam) → **malam** → PO terakhir ditutup, tidak ada PO baru sampai besok.

Bahan baku untuk semua produksi ini berasal dari belanja pemilik sendiri — setiap pembelian perlu dicatat karena langsung memengaruhi stok dan harga modal yang dipakai untuk hitung HPP.

## Prinsip Desain

1. **Produksi cook-to-order, dipicu siklus PO** (buka-tutup) — bukan target harian di muka, bukan insight manual.
2. **Resep wajib merujuk Master Bahan Baku yang sudah terdaftar** — tidak ada bahan yang bisa "muncul" langsung dari form resep tanpa riwayat pembelian & harga modal yang jelas.
3. **Setiap pembelian bahan otomatis memperbarui stok & harga modal** (rata-rata tertimbang) — harga modal tidak pernah diketik manual, selalu hasil kalkulasi dari riwayat beli.
4. **Resep tidak pernah dihapus, hanya dinonaktifkan** — HPP di-snapshot ke tiap transaksi, supaya laporan lama tidak berubah kalau harga bahan atau resep berubah belakangan.
5. **Cetak struk tetap ditunda**, kalkulasi kembalian tetap dipertahankan.
6. **Setiap entitas tercatat detail & bisa ditelusuri** — pesanan dibatalkan beserta alasannya, realisasi bahan yang benar-benar terpakai, riwayat pembelian, riwayat sesi masak — semua presisi sampai unit terkecil.

---

## Bagian A: Modul Master Data
*(dipakai kapan saja, tidak terikat siklus harian — fondasi seluruh sistem)*

### A.1 Master Bahan Baku
* CRUD dasar: nama, satuan (gram/kg/pcs/ml/liter), stok saat ini, harga modal per satuan.
* Harga modal **tidak diinput manual saat setup** — nilainya hasil kalkulasi otomatis dari riwayat pembelian di A.2. Saat bahan baru pertama kali didaftarkan, harga modal awal diambil dari pembelian pertamanya.

### A.2 Pencatatan Pembelian Bahan Baku (BARU)
* Setiap kali pemilik belanja bahan, dicatat: pilih bahan (dari A.1 — kalau benar-benar bahan baru, tambah dulu di A.1), qty dibeli, total harga atau harga per satuan, tanggal, opsional nama toko/pasar.
* Efek otomatis begitu disimpan:
  * Stok bahan baku bertambah sesuai qty.
  * **Harga modal per satuan direkalkulasi pakai rata-rata tertimbang**:
    `harga_modal_baru = (stok_lama × harga_modal_lama + qty_beli × harga_beli) / (stok_lama + qty_beli)`
* Riwayat pembelian tersimpan lengkap (tanggal, bahan, qty, harga, toko) — jadi dasar analisa tren harga bahan di Bagian C.

### A.3 Master Produk & Manajemen Resep
* Produk: nama, harga jual, status **Aktif/Nonaktif** (default Aktif untuk produk baru).
* **Resep (BOM) wajib merujuk bahan yang sudah ada di A.1** — form resep hanya menyediakan pilihan dari daftar bahan terdaftar, tidak ada opsi "ketik bahan baru" langsung dari sini. Kalau bahan yang dibutuhkan belum ada, sistem arahkan ke A.1 dulu sebelum resep bisa disimpan.
* HPP dihitung otomatis: Σ (takaran bahan × harga modal bahan saat itu).
* Setiap transaksi penjualan **snapshot HPP saat itu** ke recordnya sendiri — supaya laporan laba-rugi masa lalu tidak ikut berubah kalau harga modal bahan berubah (karena pembelian baru) atau resep diubah setelahnya.
* **Nonaktifkan Resep Lama** — hilang dari pilihan pesanan baru, data historis tetap utuh dan bisa dilihat kapan saja.
* **Tambah Resep Baru** — alur sama seperti bikin produk pertama kali: nama, harga jual, bahan & takaran per batch (dari A.1), HPP terhitung otomatis.

---

## Bagian B: Siklus Operasional Harian

### B.1 PO (Pre-Order Batch)
* Default 4 slot harian — Pagi, Siang, Sore, Malam — bisa ditambah/dikurangi kalau kebutuhan hari itu beda.
* Bikin PO: label, kuota per produk (mis. Es Teler 15 porsi, Ketan Talam 20 kotak), jam buka.
* Status: **Draft → Buka → Tutup → Selesai Masak**.
* Setelah Buka, pemilik posting iklan menyebut kuota PO (di luar aplikasi).

### B.2 Pesanan Masuk (dari WhatsApp)
* Dicatat manual: produk (dari menu Aktif saja), qty, kontak pembeli (opsional), catatan tambahan — ditautkan ke PO yang sedang Buka.
* Sisa kuota real-time per produk ditampilkan, mis. *"Es Teler: 8/15 terisi."*
* Kuota penuh atau ditutup manual → status PO **Tutup**, order tambahan diarahkan ke PO berikutnya kalau sudah dibuat.

### B.3 Produksi per PO
* Begitu PO **Tutup**, semua pesanan di dalamnya otomatis jadi satu kelompok produksi.
* Sistem hitung total kebutuhan bahan gabungan dari semua pesanan dalam PO.
* **Bahan cukup** → konfirmasi "Selesai Masak", bahan terpotong sesuai total PO, status PO jadi **Selesai Masak**, semua pesanan jadi **Siap Diambil**.
* **Bahan tidak cukup** — sistem tunjukkan bahan yang kurang, pemilik pilih per pesanan:
  * **Batalkan** — status jadi **Dibatalkan**, alasan otomatis "bahan baku tidak cukup" (bisa ditambah catatan).
  * **Tetap dimasak sebagian** — prioritas default FIFO (urut waktu pesan), bisa diubah manual, sampai kebutuhan bahan pas dengan stok tersedia. Sisanya otomatis Dibatalkan.
* Bahan terpotong & biaya dihitung dari **realisasi**, bukan rencana awal PO.
* **1 PO = 1 sesi masak = 1 catatan biaya resource (gas)** — diinput manual sebagai estimasi kasar per sesi, makin presisi seiring data terkumpul.

### B.4 Penyelesaian Pesanan & Pencatatan Penjualan
* Pesanan **Siap Diambil** + pembeli sudah bayar (COD saat ambil, atau transfer di muka) → tandai **Selesai** → pendapatan tercatat real-time per transaksi (harga × qty).
* Tidak ada pengurangan stok terpisah di sini — sudah terpotong di B.3.
* Kalkulasi kembalian tetap ada untuk transaksi COD.
* Cetak struk: ditunda — diganti ringkasan transaksi di layar sebentar.

### B.5 Tutup Order Malam & Evaluasi Harian
* Tombol **"Tutup Pesanan Hari Ini"** — kunci penerimaan pesanan baru sampai besok pagi.
* Pesanan **Dibatalkan** (dari B.3, bahan kurang) tidak berefek stok/pendapatan. **Waste** — pesanan yang sudah terlanjur dimasak tapi tidak diambil — dicatat sebagai kerugian material.
* Biaya operasional harian: daftar generik `(nama_biaya, jumlah, tanggal)` — minyak motor Rp12.000/hari, tenaga kerja Rp45.000/hari, ditambah breakdown biaya gas dari jumlah sesi masak hari itu.
* Laba rugi harian otomatis — pendapatan dikurangi HPP dinamis dan biaya operasional.

---

## Bagian C: Modul Analisis & Pelaporan

*Catatan: "market" di sini berarti pola permintaan pelanggan sendiri (dari data pesanan & penjualan internal), bukan riset pasar eksternal/kompetitor — aplikasi belum terhubung ke sumber data luar.*

* **Tren penjualan per produk** — mingguan, naik-turun tiap menu.
* **Performa per slot PO** — Pagi vs Siang vs Sore vs Malam, slot mana paling laris per produk, jadi dasar atur kuota tiap slot ke depan.
* **Laporan performa menu** — bantu keputusan rotasi resep: produk mana kandidat dinonaktifkan, bagaimana produk baru berkembang di minggu-minggu awal.
* **Laporan pembatalan & bottleneck bahan** — bahan apa yang paling sering bikin pesanan dibatalkan (dari B.3), dasar keputusan restock.
* **Tren harga beli bahan baku** — dari riwayat pembelian (A.2), kapan harga naik/turun, bantu keputusan kapan & berapa banyak belanja.
* Export csv/xlsx untuk seluruh laporan di atas.

---

## Bagian D: Modul Backup & Restore (Offline)

Karena aplikasi ini offline penuh (data cuma ada di device), backup bukan fitur tambahan — ini bagian inti supaya data tidak hilang kalau HP hilang/rusak/aplikasi ke-uninstall.

* **Dua format, dua tujuan berbeda:**
  * **Salinan `.db` (raw SQLite)** — format utama untuk restore penuh. Paling reliable karena tidak perlu proses parsing ulang, tinggal ditimpakan kembali persis seperti semula.
  * **Dump `.sql`** — opsional, isinya perintah SQL (schema + data) yang bisa dibaca manual atau dipakai migrasi ke sistem database lain nanti (relevan kalau proyek ini lanjut ke fase cloud).
  * *(csv/xlsx dari Bagian C bukan untuk restore — itu murni untuk laporan/analisis yang dibaca manusia; strukturnya tidak menyimpan relasi antar tabel.)*
* **Kapan backup dibuat**: tombol manual "Backup Sekarang", plus otomatis terpicu setiap kali tombol "Tutup Pesanan Hari Ini" (B.5) ditekan — backup harian terjadi natural tanpa perlu scheduler terpisah.
* **Di mana disimpan**: file backup disimpan di storage device, dengan opsi "Bagikan" lewat share sheet bawaan OS (kirim ke Google Drive, WhatsApp ke diri sendiri, email, dst). Aplikasi tidak upload otomatis ke cloud manapun, sesuai batasan scope personal use.
* **Restore**: pilih file backup (`.db` atau `.sql`) dari storage → konfirmasi tegas bahwa proses ini menimpa seluruh data yang ada sekarang → data dipulihkan.

---

## Ruang Lingkup: Personal Use Dulu, Generalisasi Nanti

Fokus pengembangan saat ini murni untuk kebutuhan bisnis pribadi — bukan platform lintas-UMKM dulu. Baru dipertimbangkan digeneralisasi kalau aplikasi ini terbukti benar-benar membantu penjualan.

**Di-drop dari scope sekarang**: toggle pola produksi (stok dulu vs pesanan dulu), channel pesanan selain WA manual, varian produk, template onboarding sektor F&B, multi-tenant/autentikasi/sinkronisasi cloud/model bisnis platform.

**Tetap dipertahankan meski scope personal** (keputusan skema data, murah sekarang): biaya operasional sebagai daftar generik, resource per sesi produksi sebagai entitas generik (bukan kolom khusus "biaya_gas").

---

## Roadmap: MVP vs Fase Berikutnya

| Fitur | MVP (sekarang) | Fase berikutnya |
|---|---|---|
| Master Bahan Baku + Pencatatan Pembelian (stok & harga modal otomatis) | ✅ | Dukungan multi-toko/supplier dengan histori harga per toko |
| Resep wajib merujuk Master Bahan Baku (validasi referential integrity) | ✅ | — |
| Manajemen resep (aktif/nonaktif, HPP snapshot per transaksi) | ✅ | Riwayat perubahan resep lengkap (versioning penuh) |
| PO (batch pesanan): bikin PO, kuota per produk, status buka/tutup | ✅ | Auto-tutup PO saat kuota penuh, jadwal PO berulang otomatis |
| Pesanan masuk manual dari WhatsApp, ditautkan ke PO | ✅ | Integrasi otomatis via webhook/API WhatsApp |
| Produksi per PO + penanganan bahan kurang (batal/masak sebagian FIFO) | ✅ | Prioritas otomatis berdasar riwayat pelanggan |
| Penyelesaian pesanan + pencatatan penjualan real-time | ✅ | — |
| Tutup order malam, waste, laba rugi harian | ✅ | — |
| Analisis: tren penjualan, performa slot PO, performa menu, bottleneck bahan, tren harga beli | ✅ | Proyeksi permintaan musiman |
| Export csv/xlsx untuk laporan | ✅ | Export .db penuh untuk migrasi ke sistem cloud |
| Backup manual + otomatis (.db), dump .sql opsional, restore | ✅ | Backup terjadwal ke cloud storage (Drive dsb) |
| Cetak struk | — | Modul cetak via printer thermal Bluetooth |
| Cek kapasitas maksimal otomatis | — | Dihitung otomatis begitu data historis cukup |

Struktur data (bahan baku, pembelian, resep dengan snapshot HPP, PO, pesanan, sesi masak, biaya operasional) dibuat lengkap sejak MVP, jadi seluruh kolom kanan tinggal ditambahkan sebagai lapisan baru tanpa migrasi ulang skema.