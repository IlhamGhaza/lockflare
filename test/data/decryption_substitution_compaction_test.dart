import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/substitution_compaction.dart';
import 'package:lockflare/data/decryption_substitution_compaction.dart';

void main() {
  group('DecryptionSubstitutionAndCompaction', () {
    test('decrypt reverses substitution-compaction flow', () {
      final encryptor = SubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final ciphertext = encryptor.encrypt('ABCDEFGH');

      final decryptor = DecryptionSubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final plaintext = decryptor.decrypt(ciphertext);

      expect(plaintext.trim().isNotEmpty, isTrue);
      expect(decryptor.steps, contains('Hasil dekripsi'));
    });

    test('records substitution reversal details', () {
      final encryptor = SubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final ciphertext = encryptor.encrypt('ABCDEF');

      final decryptor = DecryptionSubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      decryptor.decrypt(ciphertext);

      expect(decryptor.steps, contains('substitusi balik'));
      expect(decryptor.steps, contains('Mengonversi biner ke teks'));
    });
  });
}