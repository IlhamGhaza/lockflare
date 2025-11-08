import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/decryption_hc2.dart';
import 'package:lockflare/data/hill_chipper2.dart';

void main() {
  group('HillCipher2', () {
    test('encrypt produces ciphertext and records steps', () {
      final cipher = HillCipher2('1234');
      final ciphertext = cipher.encrypt('HELLO');

      expect(ciphertext.isNotEmpty, isTrue);
      expect(cipher.steps, contains('Ciphertext'));

      final decryptor = DecryptionHillCipher2('1234');
      final plaintext = decryptor.decrypt(ciphertext);

      expect(plaintext.contains('HELLO'), isTrue);
    });

    test('throws when key length invalid', () {
      expect(() => HillCipher2('12'), throwsException);
    });
  });
}