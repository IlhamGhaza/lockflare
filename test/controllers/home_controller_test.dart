import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lockflare/presentation/controllers/home_controller.dart';

void main() {
  group('HomeController validation', () {
    late List<String> emittedMessages;
    late HomeController controller;

    setUp(() {
      Get.testMode = true;
      emittedMessages = [];
      controller = HomeController(messageHandler: emittedMessages.add);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('requires input text', () {
      controller.process();
      expect(emittedMessages.last, 'error_empty_text'.tr);
    });

    test('requires algorithm selection', () async {
      controller.inputController.text = 'TEXT';
      await controller.process();
      expect(emittedMessages.last, 'error_select_algo'.tr);
    });

    test('rejects invalid hill key length', () async {
      controller.inputController.text = 'HELLO';
      controller.selectedAlgorithm.value = 'Hill Cipher (2x2)';
      controller.keyController.text = '12';

      await controller.process();

      expect(emittedMessages.last, 'error_hill_2x2_key'.tr);
      expect(controller.outputText.value, isEmpty);
    });

    test('process hill cipher 2x2 success', () async {
      controller.inputController.text = 'HI';
      controller.keyController.text = '1234';
      controller.selectedAlgorithm.value = 'Hill Cipher (2x2)';

      await controller.process();

      expect(emittedMessages, isEmpty);
      expect(controller.outputText.value, startsWith('Hasil Hill Cipher (2x2): '));
      expect(controller.steps.value, contains('Ciphertext'));
      expect(controller.isProcessing.value, isFalse);
    });

    test('emits error when determinant invalid', () async {
      controller.inputController.text = 'HI';
      controller.keyController.text = '1111';
      controller.selectedAlgorithm.value = 'Hill Cipher (2x2)';

      await controller.process();

      expect(emittedMessages.last, contains('Hill cipher key determinant'));
      expect(controller.outputText.value, isEmpty);
    });
  });
}
