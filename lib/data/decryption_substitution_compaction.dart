class DecryptionSubstitutionAndCompaction {
  String steps = '';
  final String alphabet;

  DecryptionSubstitutionAndCompaction(this.alphabet);

  /// Method untuk proses dekripsi
  String decrypt(String compactedInput) {
    steps = '';
    steps += ("\n=== [Substitution + Compaction - Decrypt] ===");
    steps += ("\nInput terenkripsi (binary): $compactedInput");

    // Duplikasi data yang telah dikompaksi untuk mengembalikan ke ukuran asli
    String expandedBinary = compactedInput + compactedInput;
    steps += ("\nBiner setelah ekspansi: $expandedBinary");

    // Substitusi balik menggunakan S-box
    String decryptedBinary = _reverseSubstitution(expandedBinary);
    steps += ("\nBiner setelah substitusi balik: $decryptedBinary");

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

  /// Private Method: Substitusi balik menggunakan S-box
  String _reverseSubstitution(String binary) {
    return _substitution(binary); // S-box DES bersifat reversible
  }

  /// Private Method: Substitusi menggunakan S-box
  String _substitution(String binary) {
    List<String> blocks = _chunkString(binary, 6);
    String result = '';

    for (var block in blocks) {
      // Pad block jika kurang dari 6 bit
      if (block.length < 6) {
        block = block.padRight(6, '0');
      }

      // Ambil row dan column dari block
      int row = int.parse(block[0] + block[5], radix: 2);
      int col = int.parse(block.substring(1, 5), radix: 2);

      // Gunakan S-box pertama dari DES
      int sboxValue = _getSBoxValue(row, col);
      result += sboxValue.toRadixString(2).padLeft(4, '0');
    }

    return result;
  }

  /// Private Method: Mendapatkan nilai dari S-box
  int _getSBoxValue(int row, int col) {
    // S-box pertama dari DES
    List<List<int>> sbox = [
      [14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7],
      [0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8],
      [4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0],
      [15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13]
    ];
    return sbox[row][col];
  }

  /// Private Method: Membagi string menjadi chunks
  List<String> _chunkString(String str, int size) {
    List<String> chunks = [];
    for (var i = 0; i < str.length; i += size) {
      chunks
          .add(str.substring(i, i + size > str.length ? str.length : i + size));
    }
    return chunks;
  }
}
