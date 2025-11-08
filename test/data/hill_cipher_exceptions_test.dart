import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/hill_cipher_exceptions.dart';

void main() {
  group('InvalidHillCipherKeyException', () {
    test('provides defaults when details not supplied', () {
      const exception = InvalidHillCipherKeyException(
        code: 'test_code',
        message: 'A description of the failure',
      );

      expect(exception.code, 'test_code');
      expect(exception.message, 'A description of the failure');
      expect(exception.details, isEmpty);
    });

    test('retains provided details and returns message in toString', () {
      final exception = InvalidHillCipherKeyException(
        code: 'another_code',
        message: 'Need to translate',
        details: const {'size': '2x2', 'determinant': 12},
      );

      expect(exception.details, containsPair('size', '2x2'));
      expect(exception.toString(), 'Need to translate');
    });
  });
}
