import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/data/subtitution_permutation.dart';
import 'package:lockflare/data/decryption_substitution_permutation.dart';

void main() {
  group('DecryptionSubstitutionAndPermutation', () {
    test('decrypt reverses encryption output', () {
      final encryptor = SubstitutionAndPermutation('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final ciphertext = encryptor.encrypt('ABCDEFGH');

      final decryptor = DecryptionSubstitutionAndPermutation('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final plaintext = decryptor.decrypt(ciphertext);

      expect(plaintext.contains('ABCDEFGH'), isTrue);
      expect(decryptor.steps, contains('Teks Hasil Dekripsi'));
    });

    test('records round steps during decryption', () {
      final encryptor = SubstitutionAndPermutation('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      final ciphertext = encryptor.encrypt('HIJKLMNO');

      final decryptor = DecryptionSubstitutionAndPermutation('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      decryptor.decrypt(ciphertext);

      expect(decryptor.steps, contains('Reverse Round'));
      expect(decryptor.steps, contains('Inverse Initial Permutation'));
    });
  });
}