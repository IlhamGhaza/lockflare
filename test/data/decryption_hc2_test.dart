import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/decryption_hc2.dart';
import 'package:lockflare/data/hill_chipper2.dart';

void main() {
  group('DecryptionHillCipher2', () {
    test('decrypt reverses 2x2 hill cipher encryption', () {
      final encryptor = HillCipher2('1234');
      final ciphertext = encryptor.encrypt('HI');

      final decryptor = DecryptionHillCipher2('1234');
      final plaintext = decryptor.decrypt(ciphertext);

      expect(plaintext.startsWith('HI'), isTrue);
      expect(decryptor.steps, contains('Plaintext'));
    });

    test('throws for invalid key length', () {
      expect(() => DecryptionHillCipher2('12'), throwsException);
    });
  });
}
