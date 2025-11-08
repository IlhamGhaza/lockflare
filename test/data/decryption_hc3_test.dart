import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/decryption_hc3.dart';
import 'package:lockflare/data/hill_chipper3.dart';

void main() {
  group('DecryptionHillCipher3', () {
    test('decrypt reverses 3x3 hill cipher encryption', () {
      final encryptor = HillCipher3('100010001');
      final ciphertext = encryptor.encrypt('HELLO');

      final decryptor = DecryptionHillCipher3('100010001');
      final plaintext = decryptor.decrypt(ciphertext);

      expect(plaintext.startsWith('HELLO'), isTrue);
      expect(decryptor.steps, contains('Plaintext'));
    });

    test('throws for invalid key length', () {
      expect(() => DecryptionHillCipher3('123'), throwsException);
    });
  });
}
