import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/blocking_subtitotion.dart';
import 'package:lockflare/data/decryption_blocking_substitution.dart';

void main() {
  group('DecryptionBlockingAndSubstitution', () {
    test('decrypt restores original plaintext', () {
      final encryptor = BlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final ciphertext = encryptor.encrypt('HELLO');

      final decryptor = DecryptionBlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final plaintext = decryptor.decrypt(ciphertext);

      expect(plaintext.contains('HELLO'), isTrue);
      expect(decryptor.steps, contains('Hasil dekripsi'));
    });

    test('records block processing steps', () {
      final encryptor = BlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final ciphertext = encryptor.encrypt('ABCDEFGHI');

      final decryptor = DecryptionBlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      decryptor.decrypt(ciphertext);

      expect(decryptor.steps, contains('Jumlah blok'));
      expect(decryptor.steps, contains('Hasil substitusi balik'));
    });
  });
}