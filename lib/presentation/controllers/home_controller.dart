import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/hill_cipher_exceptions.dart';
import 'algorithm_registry.dart';

class HomeController extends GetxController {
  HomeController({void Function(String message)? messageHandler})
      : _messageHandler = messageHandler;

  final inputController = TextEditingController();
  final keyController = TextEditingController();
  
  final selectedAlgorithm = Rxn<String>();
  final outputText = ''.obs;
  final steps = ''.obs;
  final isProcessing = false.obs;

  final void Function(String message)? _messageHandler;

  @override
  void onClose() {
    inputController.dispose();
    keyController.dispose();
    super.onClose();
  }

  bool _validateInput() {
    if (inputController.text.isEmpty || inputController.text.trim().isEmpty) {
      _emitMessage('error_empty_text'.tr);
      return false;
    }

    if (selectedAlgorithm.value == null || selectedAlgorithm.value!.isEmpty) {
      _emitMessage('error_select_algo'.tr);
      return false;
    }

    final descriptor = AlgorithmRegistry.findByName(selectedAlgorithm.value);
    if (descriptor == null) {
      _emitMessage('algo_not_recognized'.tr);
      return false;
    }

    final isHillCipher = descriptor.isHillCipher;
    final isDecryption = descriptor.isDecryption;

    if (isHillCipher) {
      if (keyController.text.isEmpty || keyController.text.trim().isEmpty) {
        _emitMessage('error_hill_key'.tr);
        return false;
      }

      if (descriptor.name.contains("3x3") &&
          keyController.text.length != 9) {
        _emitMessage('error_hill_3x3_key'.tr);
        return false;
      }

      if (descriptor.name.contains("2x2") &&
          keyController.text.length != 4) {
        _emitMessage('error_hill_2x2_key'.tr);
        return false;
      }
    } else {
      if (!isDecryption && inputController.text.length > 8) {
        _emitMessage('error_text_too_long'.tr);
        return false;
      }

      if (keyController.text.isEmpty || keyController.text.trim().isEmpty) {
        _emitMessage('error_empty_key'.tr);
        return false;
      }

      if (keyController.text.length > 8) {
        _emitMessage('error_key_too_long'.tr);
        return false;
      }
    }

    return true;
  }

  void _emitMessage(String message) {
    final handler = _messageHandler;
    if (handler != null) {
      handler(message);
      return;
    }
    _showDialog(message);
  }

  void _showDialog(String message) {
    if (kIsWeb || Get.context != null && Theme.of(Get.context!).platform == TargetPlatform.linux) {
      Get.dialog(
        AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      Get.snackbar(
        'Info',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> process() async {
    if (!_validateInput()) return;

    isProcessing.value = true;
    outputText.value = '';
    steps.value = '';

    String input = inputController.text.trim();
    String keyInput = keyController.text.trim();
    try {
      final descriptor = AlgorithmRegistry.findByName(selectedAlgorithm.value);
      if (descriptor == null) {
        outputText.value = 'algo_not_recognized'.tr;
        return;
      }

      final execution = descriptor.executor(input, keyInput);
      outputText.value = execution.output;
      steps.value = execution.steps;
    } on InvalidHillCipherKeyException catch (e) {
      final sizeParam = e.details['size']?.toString();
      final translated = sizeParam != null
          ? e.code.trParams({'size': sizeParam})
          : e.code.tr;
      final message = translated == e.code ? e.message : translated;

      outputText.value = '';
      steps.value = '';
      _emitMessage(message);
    } catch (e) {
      outputText.value = "Error: ${e.toString()}";
    } finally {
      isProcessing.value = false;
    }
  }

  int? getMaxLength() {
    final descriptor = AlgorithmRegistry.findByName(selectedAlgorithm.value);
    if (descriptor == null) {
      return 8;
    }

    if (descriptor.isHillCipher) {
      return null;
    }

    if (descriptor.isDecryption) {
      return null;
    }

    return 8;
  }

  int? getKeyMaxLength() {
    if (selectedAlgorithm.value?.contains("Hill Cipher") ?? false) {
      return selectedAlgorithm.value!.contains("3x3") ? 9 : 4;
    }
    return 8;
  }

  String getInputHint() {
    if (selectedAlgorithm.value?.contains("Hill Cipher") ?? false) {
      return 'enter_text'.tr;
    }
    return 'enter_text_max'.tr;
  }

  String getKeyHint() {
    if (selectedAlgorithm.value?.contains("Hill Cipher") ?? false) {
      return 'enter_key_number'.tr;
    }
    return 'enter_key_max'.tr;
  }
}
