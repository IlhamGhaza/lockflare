import 'dart:math' as math;

class DecryptionPermutationAndCompaction {
  String steps = '';

  /// Method untuk proses dekripsi
  String decrypt(String compactedInput) {
    steps = '';
    steps += ("\n=== [Permutation + Compaction - Decrypt] ===");
    steps += ("\nInput terenkripsi (binary): $compactedInput");

    // Duplikasi data yang telah dikompaksi untuk mengembalikan ke ukuran asli
    String expandedBinary = compactedInput + compactedInput;
    steps += ("\nBiner setelah ekspansi: $expandedBinary");

    // Inverse Initial Permutation
    String decryptedBinary = _inverseInitialPermutation(expandedBinary);
    steps += ("\nBiner setelah Inverse Initial Permutation: $decryptedBinary");

    // Konversi kembali ke teks
    String result = _binaryToText(decryptedBinary);
    steps += ("\nHasil dekripsi: $result");

    return result;
  }

  /// Private Method: Konversi biner ke teks
  String _binaryToText(String binary) {
    steps += ("\nMengonversi biner ke teks...");
    List<String> chunks = _chunkString(binary, 8);
    return chunks
        .map((chunk) => String.fromCharCode(int.parse(chunk, radix: 2)))
        .join()
        .replaceAll('0', ''); // Remove padding
  }

  /// Private Method: Inverse Initial Permutation (IP^-1)
  String _inverseInitialPermutation(String binary) {
    steps += ("\nMelakukan Inverse Initial Permutation...");
    List<int> ipInverseTable = [
      40, 8, 48, 16, 56, 24, 64, 32,
      39, 7, 47, 15, 55, 23, 63, 31,
      38, 6, 46, 14, 54, 22, 62, 30,
      37, 5, 45, 13, 53, 21, 61, 29,
      36, 4, 44, 12, 52, 20, 60, 28,
      35, 3, 43, 11, 51, 19, 59, 27,
      34, 2, 42, 10, 50, 18, 58, 26,
      33, 1, 41, 9, 49, 17, 57, 25
    ];
    return _permute(binary, ipInverseTable);
  }

  /// Private Method: Permutasi
  String _permute(String input, List<int> table) {
    List<String> bits = input.split('');
    String result = '';
    for (int pos in table) {
      if (pos <= bits.length) {
        result += bits[pos - 1];
      } else {
        result += '0'; // Padding jika posisi melebihi panjang input
      }
    }
    return result;
  }

  /// Private Method: Membagi string menjadi chunks
  List<String> _chunkString(String str, int size) {
    List<String> chunks = [];
    for (var i = 0; i < str.length; i += size) {
      chunks.add(str.substring(i, math.min(i + size, str.length)));
    }
    return chunks;
  }
}
