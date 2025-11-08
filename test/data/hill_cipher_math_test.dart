import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/hill_cipher_exceptions.dart';
import 'package:lockflare/data/hill_cipher_math.dart';

void main() {
  group('Hill cipher math helpers', () {
    test('normalizeHillMod wraps negative values', () {
      expect(normalizeHillMod(40), 3);
      expect(normalizeHillMod(-1), kHillCipherModulus - 1);
    });

    test('ensureHillDeterminantInvertible throws when gcd != 1', () {
      expect(
        () => ensureHillDeterminantInvertible(0, size: '2x2'),
        throwsA(isA<InvalidHillCipherKeyException>()),
      );
    });

    test('hillCipherModInverse returns correct modular inverse', () {
      final inverse = hillCipherModInverse(3, size: '2x2');
      expect((3 * inverse) % kHillCipherModulus, 1);
    });
  });
}
