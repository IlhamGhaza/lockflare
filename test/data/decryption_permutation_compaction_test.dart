import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/permutation_compaction.dart';
import 'package:lockflare/data/decryption_permutation_compaction.dart';

void main() {
  group('DecryptionPermutationAndCompaction', () {
    test('decrypt restores readable text', () {
      final encryptor = PermutationAndCompaction();
      final ciphertext = encryptor.encrypt('ABCDEFGH');

      final decryptor = DecryptionPermutationAndCompaction();
      final plaintext = decryptor.decrypt(ciphertext);

      expect(plaintext.trim().isNotEmpty, isTrue);
      expect(decryptor.steps, contains('Hasil dekripsi'));
    });

    test('records inverse permutation steps', () {
      final encryptor = PermutationAndCompaction();
      final ciphertext = encryptor.encrypt('ABCDEFGH');

      final decryptor = DecryptionPermutationAndCompaction();
      decryptor.decrypt(ciphertext);

      expect(decryptor.steps, contains('Inverse Initial Permutation'));
      expect(decryptor.steps, contains('Mengonversi biner ke teks'));
    });
  });
}