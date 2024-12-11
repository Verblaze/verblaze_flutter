/// Represents a language in the system
class Language {
  final String code;
  final String generalName;
  final String localName;

  Language({
    required this.code,
    required this.generalName,
    required this.localName,
  });

  /// Creates a Language instance from JSON
  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'],
      generalName: json['general'],
      localName: json['local'],
    );
  }

  /// Converts Language instance to JSON
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'generalName': generalName,
      'localName': localName,
    };
  }

  @override
  String toString() {
    return 'Language(code: $code, generalName: $generalName, localName: $localName)';
  }

  @override
  int get hashCode => code.hashCode ^ generalName.hashCode ^ localName.hashCode;
}
