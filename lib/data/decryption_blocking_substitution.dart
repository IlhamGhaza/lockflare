import 'dart:math' as math;

class DecryptionBlockingAndSubstitution {
  final String alphabet;
  String steps = '';

  DecryptionBlockingAndSubstitution(this.alphabet);

  /// Method untuk proses dekripsi
  String decrypt(String input) {
    steps = '';
    steps += ("\n=== [Blocking + Substitution - Decrypt] ===");
    steps += ("\nInput (binary): $input");

    // Bagi input menjadi blok 32-bit
    List<String> blocks = _chunkString(input, 32);
    steps += ("\nJumlah blok: ${blocks.length}");

    // Lakukan substitusi balik pada setiap blok
    List<String> decryptedBlocks = blocks.map((block) {
      String decrypted = _blockSubstitution(
          block); // Substitusi yang sama karena merupakan invers dirinya sendiri
      steps += ("\nHasil substitusi balik: $decrypted");
      return decrypted;
    }).toList();

    // Gabungkan hasil
    String binaryResult = decryptedBlocks.join();
    steps += ("\nBiner hasil dekripsi: $binaryResult");

    // Konversi kembali ke teks
    String textResult = _binaryToText(binaryResult);
    steps += ("\nHasil dekripsi: $textResult");

    return textResult;
  }

  /// Private method: Konversi biner ke teks
  String _binaryToText(String binary) {
    steps += ("\nMengonversi biner ke teks...");
    List<String> chunks = _chunkString(binary, 8);
    return chunks
        .map((chunk) => String.fromCharCode(int.parse(chunk, radix: 2)))
        .join()
        .replaceAll('0', ''); // Remove padding
  }

  /// Private method: Substitusi untuk satu blok
  String _blockSubstitution(String block) {
    return block.split('').map((bit) => bit == '0' ? '1' : '0').join();
  }

  /// Private method: Membagi string menjadi blok-blok
  List<String> _chunkString(String str, int size) {
    return List.generate((str.length / size).ceil(),
        (i) => str.substring(i * size, math.min((i + 1) * size, str.length)));
  }
}
