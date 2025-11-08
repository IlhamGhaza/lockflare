import 'dart:math' as math;

class DecryptionSubstitutionAndPermutation {
  final String alphabet;
  String steps = "";

  // S-box tables as per DES standard
  static final List<List<List<int>>> sBoxes = [
    [
      [14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7],
      [0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8],
      [4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0],
      [15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13]
    ],
  ];

  DecryptionSubstitutionAndPermutation(this.alphabet);

  String decrypt(String hexInput) {
    steps = "";
    steps += ("\n=== [Substitution + Permutation - Decrypt] ===");
    steps += ("\nInput Hexa: $hexInput");

    // Convert hex to binary
    String binaryInput = _hexToBinary(hexInput);
    steps += ("\nBiner dari Hexa: $binaryInput");

    // Ensure 64-bit length
    if (binaryInput.length < 64) {
      binaryInput = binaryInput.padLeft(64, '0');
      steps += ("\nBiner setelah padding: $binaryInput");
    }

    // Inverse Final Permutation
    String afterFinalPerm = _inverseFinalPermutation(binaryInput);
    steps += ("\nBiner Setelah Inverse Final Permutation: $afterFinalPerm");

    // Split into left and right halves (note: combined was right+left in encrypt)
    String right = afterFinalPerm.substring(0, 32);
    String left = afterFinalPerm.substring(32);
    steps += ("\nRight half: $right");
    steps += ("\nLeft half: $left");

    // Reverse Feistel network rounds (from round 2 to 1)
    for (int round = 2; round >= 1; round--) {
      steps += ("\nReverse Round $round:");
      String temp = left;
      left = _xor(right, _feistelFunction(left, round));
      right = temp;
      steps += ("\nRight: $right");
      steps += ("\nLeft: $left");
    }

    // Combine halves (left + right)
    String combined = left + right;
    steps += ("\nCombined (LR): $combined");

    // Inverse Initial Permutation
    String finalBinary = _inverseInitialPermutation(combined);
    steps += ("\nBiner Setelah Inverse Initial Permutation: $finalBinary");

    // Convert back to text
    String resultText = _binaryToText(finalBinary);
    steps += ("\nTeks Hasil Dekripsi: $resultText");

    return resultText;
  }

  String _binaryToText(String binary) {
    steps += ("\nMengonversi biner ke teks...");
    List<String> chunks = _chunkString(binary, 8);
    return chunks
        .map((bin) => String.fromCharCode(int.parse(bin, radix: 2)))
        .join()
        .replaceAll('0', ''); // Remove padding
  }


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

  String _feistelFunction(String input, int round) {
    // Expansion
    String expanded = _expansion(input);
    steps += ("\nAfter expansion: $expanded");

    // Key mixing (simplified for demonstration)
    String roundKey = _generateRoundKey(round);
    String mixed = _xor(expanded, roundKey);
    steps += ("\nAfter key mixing: $mixed");

    // S-box substitution
    String substituted = _sBoxSubstitution(mixed);
    steps += ("\nAfter S-box substitution: $substituted");

    // P-box permutation
    String permuted = _pBoxPermutation(substituted);
    steps += ("\nAfter P-box permutation: $permuted");

    return permuted;
  }

  String _expansion(String input) {
    List<int> expansionTable = [
      32, 1, 2, 3, 4, 5,
      4, 5, 6, 7, 8, 9,
      8, 9, 10, 11, 12, 13,
      12, 13, 14, 15, 16, 17,
      16, 17, 18, 19, 20, 21,
      20, 21, 22, 23, 24, 25,
      24, 25, 26, 27, 28, 29,
      28, 29, 30, 31, 32, 1
    ];
    return _permute(input, expansionTable);
  }

  String _generateRoundKey(int round) {
    return '1' * 48;
  }

  String _sBoxSubstitution(String input) {
    List<String> blocks = _chunkString(input, 6);
    String result = '';

    for (int i = 0; i < blocks.length; i++) {
      String block = blocks[i];
      int row = int.parse(block[0] + block[5], radix: 2);
      int col = int.parse(block.substring(1, 5), radix: 2);

      int sBoxValue = sBoxes[0][row][col];
      result += sBoxValue.toRadixString(2).padLeft(4, '0');
    }

    return result;
  }

  String _pBoxPermutation(String input) {
    List<int> pBox = [
      16, 7, 20, 21, 29, 12, 28, 17,
      1, 15, 23, 26, 5, 18, 31, 10,
      2, 8, 24, 14, 32, 27, 3, 9,
      19, 13, 30, 6, 22, 11, 4, 25
    ];
    return _permute(input, pBox);
  }


  String _inverseFinalPermutation(String binary) {
    steps += ("\nMelakukan Inverse Final Permutation...");
    List<int> fpInverseTable = [
      58, 50, 42, 34, 26, 18, 10, 2,
      60, 52, 44, 36, 28, 20, 12, 4,
      62, 54, 46, 38, 30, 22, 14, 6,
      64, 56, 48, 40, 32, 24, 16, 8,
      57, 49, 41, 33, 25, 17, 9, 1,
      59, 51, 43, 35, 27, 19, 11, 3,
      61, 53, 45, 37, 29, 21, 13, 5,
      63, 55, 47, 39, 31, 23, 15, 7
    ];
    return _permute(binary, fpInverseTable);
  }

  String _permute(String input, List<int> table) {
    List<String> bits = input.split('');
    String result = '';
    for (int pos in table) {
      if (pos <= bits.length) {
        result += bits[pos - 1];
      } else {
        result += '0';
      }
    }
    return result;
  }

  String _xor(String a, String b) {
    if (a.length != b.length) {
      int maxLength = math.max(a.length, b.length);
      a = a.padLeft(maxLength, '0');
      b = b.padLeft(maxLength, '0');
    }

    List<String> result = List<String>.filled(a.length, '0');
    for (int i = 0; i < a.length; i++) {
      result[i] = (a[i] != b[i]) ? '1' : '0';
    }
    return result.join();
  }

  String _hexToBinary(String hex) {
    steps += ("\nMengonversi heksadesimal ke biner...");
    return hex
        .split('')
        .map((char) =>
            int.parse(char, radix: 16).toRadixString(2).padLeft(4, '0'))
        .join();
  }

  List<String> _chunkString(String str, int size) {
    return List.generate((str.length / size).ceil(),
        (i) => str.substring(i * size, math.min((i + 1) * size, str.length)));
  }
}
