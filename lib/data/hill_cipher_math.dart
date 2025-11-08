import 'package:flutter/foundation.dart';

import 'hill_cipher_exceptions.dart';

const int kHillCipherModulus = 37;

int normalizeHillMod(int value) {
  final normalized = value % kHillCipherModulus;
  return normalized >= 0 ? normalized : normalized + kHillCipherModulus;
}

int _gcd(int a, int b) {
  var x = a.abs();
  var y = b.abs();

  while (y != 0) {
    final temp = x % y;
    x = y;
    y = temp;
  }

  return x;
}

int ensureHillDeterminantInvertible(int determinant, {required String size}) {
  final normalizedDet = normalizeHillMod(determinant);
  if (_gcd(normalizedDet, kHillCipherModulus) != 1) {
    debugPrint('HillCipher determinant not invertible: $normalizedDet for $size');
    throw InvalidHillCipherKeyException(
      code: 'error_hill_key_not_invertible',
      message:
          'Hill cipher key determinant $normalizedDet is not invertible modulo $kHillCipherModulus.',
      details: {
        'size': size,
        'determinant': normalizedDet,
      },
    );
  }
  return normalizedDet;
}

int hillCipherModInverse(int determinant, {required String size}) {
  final normalizedDet = ensureHillDeterminantInvertible(
    determinant,
    size: size,
  );

  for (var x = 1; x < kHillCipherModulus; x++) {
    if ((normalizedDet * x) % kHillCipherModulus == 1) {
      return x;
    }
  }

  throw InvalidHillCipherKeyException(
    code: 'error_hill_key_not_invertible',
    message:
        'Hill cipher key determinant $normalizedDet does not have a modular inverse under $kHillCipherModulus.',
    details: {
      'size': size,
      'determinant': normalizedDet,
    },
  );
}
