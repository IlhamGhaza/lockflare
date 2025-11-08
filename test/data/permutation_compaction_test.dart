import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/permutation_compaction.dart';

void main() {
  group('PermutationAndCompaction', () {
    test('encrypt halves the binary length', () {
      final algo = PermutationAndCompaction();
      final result = algo.encrypt('ABCD1234');

      expect(result.length, 32);
      expect(algo.steps, contains('Hasil setelah kompaksi'));
    });

    test('decrypt output retains block length', () {
      final algo = PermutationAndCompaction();
      final encrypted = algo.encrypt('ABCDEFGH');
      final decrypted = algo.decrypt(encrypted);

      expect(decrypted.length, 8);
      expect(algo.steps, contains('Hasil dekripsi'));
    });
  });
}
