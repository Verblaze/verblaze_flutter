class VerblazeException implements Exception {
  final String message;

  VerblazeException(this.message);

  @override
  String toString() => 'VerblazeException: $message';
}
