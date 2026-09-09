/// Pembagian biaya belanja borongan ke tiap bahan (new_flow.md A.2).
///
/// Uang selalu bilangan bulat Rupiah, jadi pembagian rata hampir selalu
/// menyisakan remainder. Sisa itu dibebankan ke baris terakhir supaya jumlah
/// seluruh alokasi **persis** sama dengan yang benar-benar dibayar — kalau
/// tidak, harga modal hasil rata-rata tertimbang ikut meleset.
List<int> allocateEvenly({
  required int totalPriceRupiah,
  required int lineCount,
}) {
  if (lineCount <= 0) {
    throw ArgumentError.value(lineCount, 'lineCount', 'Minimal 1 baris');
  }
  if (totalPriceRupiah < 0) {
    throw ArgumentError.value(
      totalPriceRupiah,
      'totalPriceRupiah',
      'Total tidak boleh negatif',
    );
  }

  final base = totalPriceRupiah ~/ lineCount;
  final allocations = List<int>.filled(lineCount, base);
  allocations[lineCount - 1] = totalPriceRupiah - base * (lineCount - 1);
  return allocations;
}
