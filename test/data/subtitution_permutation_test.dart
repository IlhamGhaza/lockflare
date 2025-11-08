import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/subtitution_permutation.dart';

void main() {
  group('SubstitutionAndPermutation', () {
    test('encrypt produces hex output with steps', () {
      final algo = SubstitutionAndPermutation('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final result = algo.encrypt('HELLO');

      expect(result.length, greaterThan(0));
      expect(algo.steps, contains('[Substitution + Permutation - Encrypt]'));
    });

    test('decrypt reverses encrypt result', () {
      final algo = SubstitutionAndPermutation('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final encrypted = algo.encrypt('ABCDEFGH');
      final decrypted = algo.decrypt(encrypted);

      expect(decrypted.trim().substring(0, 8), 'ABCDEFGH');
      expect(algo.steps, contains('[Substitution + Permutation - Decrypt]'));
    });
  });
}