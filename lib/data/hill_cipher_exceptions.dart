class InvalidHillCipherKeyException implements Exception {
  final String code;
  final String message;
  final Map<String, dynamic> details;

  const InvalidHillCipherKeyException({
    required this.code,
    required this.message,
    this.details = const {},
  });

  @override
  String toString() => message;
}
