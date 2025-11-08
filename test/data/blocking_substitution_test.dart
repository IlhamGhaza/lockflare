import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/blocking_subtitotion.dart';

void main() {
  group('BlockingAndSubstitution', () {
    test('encrypt pads to 8 characters and returns binary string', () {
      final algo = BlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final encrypted = algo.encrypt('AB');

      expect(encrypted.length, 64);
      expect(encrypted, isNotEmpty);
      expect(algo.steps, contains('Input setelah padding'));
    });

    test('decrypt reverses encrypt', () {
      final algo = BlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final encrypted = algo.encrypt('ABCD');
      final decrypted = algo.decrypt(encrypted);

      expect(decrypted.startsWith('ABCD'), isTrue);
      expect(algo.steps, contains('Hasil dekripsi'));
    });
  });
}
