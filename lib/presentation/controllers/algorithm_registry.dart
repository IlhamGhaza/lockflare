import '../../data/blocking_subtitotion.dart';
import '../../data/decryption_blocking_substitution.dart';
import '../../data/decryption_hc2.dart';
import '../../data/decryption_hc3.dart';
import '../../data/decryption_permutation_compaction.dart';
import '../../data/decryption_substitution_compaction.dart';
import '../../data/decryption_substitution_permutation.dart';
import '../../data/hill_chipper2.dart';
import '../../data/hill_chipper3.dart';
import '../../data/permutation_compaction.dart';
import '../../data/substitution_compaction.dart';
import '../../data/subtitution_permutation.dart';

class AlgorithmExecutionResult {
  final String output;
  final String steps;

  const AlgorithmExecutionResult({
    required this.output,
    required this.steps,
  });
}

typedef AlgorithmExecutor = AlgorithmExecutionResult Function(
  String input,
  String key,
);

class AlgorithmDescriptor {
  final String name;
  final bool isHillCipher;
  final bool isDecryption;
  final AlgorithmExecutor executor;

  const AlgorithmDescriptor({
    required this.name,
    required this.executor,
    this.isHillCipher = false,
    this.isDecryption = false,
  });
}

class AlgorithmRegistry {
  static const List<AlgorithmDescriptor> _orderedAlgorithms = [
    AlgorithmDescriptor(
      name: 'Substitusi + Permutasi',
      executor: _runSubstitusiPermutasiEncrypt,
    ),
    AlgorithmDescriptor(
      name: '[Decryption] Substitusi + Permutasi',
      isDecryption: true,
      executor: _runSubstitusiPermutasiDecrypt,
    ),
    AlgorithmDescriptor(
      name: 'Permutasi + Compaction',
      executor: _runPermutasiCompactionEncrypt,
    ),
    AlgorithmDescriptor(
      name: '[Decryption] Permutasi + Compaction',
      isDecryption: true,
      executor: _runPermutasiCompactionDecrypt,
    ),
    AlgorithmDescriptor(
      name: 'Blocking + Substitusi',
      executor: _runBlockingSubstitusiEncrypt,
    ),
    AlgorithmDescriptor(
      name: '[Decryption] Blocking + Substitusi',
      isDecryption: true,
      executor: _runBlockingSubstitusiDecrypt,
    ),
    AlgorithmDescriptor(
      name: 'Substitusi + Compaction',
      executor: _runSubstitusiCompactionEncrypt,
    ),
    AlgorithmDescriptor(
      name: '[Decryption] Substitusi + Compaction',
      isDecryption: true,
      executor: _runSubstitusiCompactionDecrypt,
    ),
    AlgorithmDescriptor(
      name: 'Hill Cipher (2x2)',
      isHillCipher: true,
      executor: _runHillCipher2Encrypt,
    ),
    AlgorithmDescriptor(
      name: '[Decryption] Hill Cipher (2x2)',
      isHillCipher: true,
      isDecryption: true,
      executor: _runHillCipher2Decrypt,
    ),
    AlgorithmDescriptor(
      name: 'Hill Cipher (3x3)',
      isHillCipher: true,
      executor: _runHillCipher3Encrypt,
    ),
    AlgorithmDescriptor(
      name: '[Decryption] Hill Cipher (3x3)',
      isHillCipher: true,
      isDecryption: true,
      executor: _runHillCipher3Decrypt,
    ),
  ];

  static final Map<String, AlgorithmDescriptor> _algorithms = {
    for (final descriptor in _orderedAlgorithms) descriptor.name: descriptor,
  };

  static AlgorithmDescriptor? findByName(String? name) {
    if (name == null) return null;
    return _algorithms[name];
  }

  static List<String> get names =>
      _orderedAlgorithms.map((descriptor) => descriptor.name).toList(growable: false);
}

AlgorithmExecutionResult _runSubstitusiPermutasiEncrypt(
  String input,
  String _,
) {
  final sp = SubstitutionAndPermutation('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  final paddedInput = input.padRight(8, '0');

  try {
    final binaryInput = _toBinary(paddedInput);
    final encrypted = sp.encrypt(paddedInput);
    return AlgorithmExecutionResult(
      output: '=== Substitusi + Permutasi (Encrypt) ===\n'
          'Biner Input: $binaryInput\n'
          'Hasil Hexa: $encrypted',
      steps: sp.steps,
    );
  } catch (e) {
    return AlgorithmExecutionResult(
      output: 'Error pada algoritma Substitusi + Permutasi: ${e.toString()}',
      steps: sp.steps,
    );
  }
}

AlgorithmExecutionResult _runSubstitusiPermutasiDecrypt(
  String input,
  String _,
) {
  final sp = DecryptionSubstitutionAndPermutation('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

  try {
    final decrypted = sp.decrypt(input);
    return AlgorithmExecutionResult(
      output: '=== Substitusi + Permutasi (Decrypt) ===\n'
          'Input Hexa: $input\n'
          'Hasil Dekripsi: $decrypted',
      steps: sp.steps,
    );
  } catch (e) {
    return AlgorithmExecutionResult(
      output:
          'Error pada dekripsi Substitusi + Permutasi: ${e.toString()}',
      steps: sp.steps,
    );
  }
}

AlgorithmExecutionResult _runPermutasiCompactionEncrypt(
  String input,
  String _,
) {
  final pc = PermutationAndCompaction();
  final paddedInput = input.padRight(8, '0');

  final binaryInput = pc.toBinary(paddedInput);
  final compacted = pc.encrypt(paddedInput);

  return AlgorithmExecutionResult(
    output: 'Biner Input: $binaryInput\nHasil Compacting: $compacted',
    steps: pc.steps,
  );
}

AlgorithmExecutionResult _runPermutasiCompactionDecrypt(
  String input,
  String _,
) {
  final pc = DecryptionPermutationAndCompaction();

  try {
    final decrypted = pc.decrypt(input);
    return AlgorithmExecutionResult(
      output: '=== Permutasi + Compaction (Decrypt) ===\n'
          'Input: $input\n'
          'Hasil Dekripsi: $decrypted',
      steps: pc.steps,
    );
  } catch (e) {
    return AlgorithmExecutionResult(
      output:
          'Error pada dekripsi Permutasi + Compaction: ${e.toString()}',
      steps: pc.steps,
    );
  }
}

AlgorithmExecutionResult _runBlockingSubstitusiEncrypt(
  String input,
  String _,
) {
  final bs = BlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  final paddedInput = input.padRight(8, '0');

  final binaryInput = bs.toBinary(paddedInput);
  final substituted = bs.encrypt(paddedInput);

  return AlgorithmExecutionResult(
    output: 'Biner Input: $binaryInput\nHasil Substitusi: $substituted',
    steps: bs.steps,
  );
}

AlgorithmExecutionResult _runBlockingSubstitusiDecrypt(
  String input,
  String _,
) {
  final bs = DecryptionBlockingAndSubstitution('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

  try {
    final decrypted = bs.decrypt(input);
    return AlgorithmExecutionResult(
      output: '=== Blocking + Substitusi (Decrypt) ===\n'
          'Input: $input\n'
          'Hasil Dekripsi: $decrypted',
      steps: bs.steps,
    );
  } catch (e) {
    return AlgorithmExecutionResult(
      output:
          'Error pada dekripsi Blocking + Substitusi: ${e.toString()}',
      steps: bs.steps,
    );
  }
}

AlgorithmExecutionResult _runSubstitusiCompactionEncrypt(
  String input,
  String _,
) {
  final sc = SubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  final paddedInput = input.padRight(8, '0');

  final binaryInput = sc.toBinary(paddedInput);
  final compacted = sc.encrypt(paddedInput);

  return AlgorithmExecutionResult(
    output: 'Biner Input: $binaryInput\nHasil Compacting: $compacted',
    steps: sc.steps,
  );
}

AlgorithmExecutionResult _runSubstitusiCompactionDecrypt(
  String input,
  String _,
) {
  final sc = DecryptionSubstitutionAndCompaction('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

  try {
    final decrypted = sc.decrypt(input);
    return AlgorithmExecutionResult(
      output: '=== Substitusi + Compaction (Decrypt) ===\n'
          'Input: $input\n'
          'Hasil Dekripsi: $decrypted',
      steps: sc.steps,
    );
  } catch (e) {
    return AlgorithmExecutionResult(
      output:
          'Error pada dekripsi Substitusi + Compaction: ${e.toString()}',
      steps: sc.steps,
    );
  }
}

AlgorithmExecutionResult _runHillCipher2Encrypt(
  String input,
  String key,
) {
  final hillCipher = HillCipher2(key);
  final result = hillCipher.encrypt(input);

  return AlgorithmExecutionResult(
    output: 'Hasil Hill Cipher (2x2): $result',
    steps: hillCipher.steps,
  );
}

AlgorithmExecutionResult _runHillCipher2Decrypt(
  String input,
  String key,
) {
  final hillCipher = DecryptionHillCipher2(key);
  final result = hillCipher.decrypt(input);

  return AlgorithmExecutionResult(
    output: 'Hasil Hill Cipher (2x2): $result',
    steps: hillCipher.steps,
  );
}

AlgorithmExecutionResult _runHillCipher3Encrypt(
  String input,
  String key,
) {
  final hillCipher = HillCipher3(key);
  final result = hillCipher.encrypt(input);

  return AlgorithmExecutionResult(
    output: 'Hasil Hill Cipher (3x3): $result',
    steps: hillCipher.steps,
  );
}

AlgorithmExecutionResult _runHillCipher3Decrypt(
  String input,
  String key,
) {
  final hillCipher = DecryptionHillCipher3(key);
  final result = hillCipher.decrypt(input);

  return AlgorithmExecutionResult(
    output: 'Hasil Hill Cipher (3x3): $result',
    steps: hillCipher.steps,
  );
}

String _toBinary(String text) {
  return text.codeUnits
      .map((char) => char.toRadixString(2).padLeft(8, '0'))
      .join();
}
