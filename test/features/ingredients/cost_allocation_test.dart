import 'package:dapur_kelaris/features/ingredients/domain/cost_allocation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('allocateEvenly', () {
    test('splits a divisible total into equal shares', () {
      expect(allocateEvenly(totalPriceRupiah: 30000, lineCount: 3), [
        10000,
        10000,
        10000,
      ]);
    });

    test('puts the integer remainder on the last line', () {
      // Rp20.000 dibagi 3 bahan: 6666 + 6666 + 6668.
      final shares = allocateEvenly(totalPriceRupiah: 20000, lineCount: 3);

      expect(shares, [6666, 6666, 6668]);
      expect(
        shares.reduce((a, b) => a + b),
        20000,
        reason: 'jumlah alokasi harus persis sama dengan yang dibayar',
      );
    });

    test('gives a single line the whole amount', () {
      expect(allocateEvenly(totalPriceRupiah: 17777, lineCount: 1), [17777]);
    });

    test('never loses a rupiah for any split', () {
      for (var total = 1; total <= 200; total++) {
        for (var lines = 1; lines <= 7; lines++) {
          final shares = allocateEvenly(
            totalPriceRupiah: total,
            lineCount: lines,
          );
          expect(shares, hasLength(lines));
          expect(shares.reduce((a, b) => a + b), total);
        }
      }
    });

    test('rejects a line count below one', () {
      expect(
        () => allocateEvenly(totalPriceRupiah: 1000, lineCount: 0),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
