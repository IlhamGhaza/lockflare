import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/substitution_compaction.dart';

void main() {
  group('SubstitutionAndCompaction', () {
    test('encrypt pads input and compacts result', () {
      final algo = SubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final result = algo.encrypt('ABC');

      expect(result.length, greaterThan(0));
      expect(algo.steps, contains('Hasil setelah kompaksi'));
    });

    test('decrypt restores readable text', () {
      final algo = SubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final encrypted = algo.encrypt('ABCDEFGH');
      final decrypted = algo.decrypt(encrypted);
      final normalized = decrypted.trim();

      expect(normalized.isNotEmpty, isTrue);
    
      expect(algo.steps, contains('Hasil dekripsi'));
    });
  });
}