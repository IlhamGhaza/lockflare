import 'package:flutter_test/flutter_test.dart';
import 'package:lockflare/presentation/controllers/algorithm_registry.dart';

void main() {
  group('AlgorithmRegistry', () {
    test('exposes ordered algorithm names', () {
      final names = AlgorithmRegistry.names;

      expect(names.first, 'Substitusi + Permutasi');
      expect(names.contains('Hill Cipher (3x3)'), isTrue);
      expect(names.length, greaterThan(5));
    });

    test('findByName returns descriptor with metadata', () {
      final descriptor = AlgorithmRegistry.findByName('Hill Cipher (2x2)');

      expect(descriptor, isNotNull);
      expect(descriptor!.isHillCipher, isTrue);
      expect(descriptor.isDecryption, isFalse);
    });

    test('executors produce output and steps', () {
      final encryptDescriptor = AlgorithmRegistry.findByName('Hill Cipher (2x2)');
      final decryptDescriptor = AlgorithmRegistry.findByName('[Decryption] Hill Cipher (2x2)');

      final encryptResult = encryptDescriptor!.executor('HELLO', '1234');
      final decryptResult = decryptDescriptor!.executor(encryptResult.output.split(': ').last, '1234');

      expect(encryptResult.output, contains('Hill Cipher (2x2)'));
      expect(encryptResult.steps.isNotEmpty, isTrue);
      expect(decryptResult.output, contains('Hill Cipher (2x2)'));
    });
  });
}