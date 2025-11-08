import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/decryption_hc3.dart';
import 'package:lockflare/data/hill_chipper3.dart';

void main() {
  group('HillCipher3', () {
    test('encrypt produces ciphertext and records steps', () {
      final cipher = HillCipher3('100010001');
      final ciphertext = cipher.encrypt('HELLO');

      expect(ciphertext.isNotEmpty, isTrue);
      expect(cipher.steps, contains('Ciphertext'));

      final decryptor = DecryptionHillCipher3('100010001');
      final plaintext = decryptor.decrypt(ciphertext);

      expect(plaintext.startsWith('HELLO'), isTrue);
    });

    test('throws when key length invalid', () {
      expect(() => HillCipher3('123'), throwsException);
    });
  });
}