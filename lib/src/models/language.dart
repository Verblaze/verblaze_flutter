/// Represents a language in the system
class Language {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  /// Creates a Language instance from JSON
  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'],
      name: json['name'],
      nativeName: json['nativeName'],
      flag: json['flag'],
    );
  }

  /// Converts Language instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'nativeName': nativeName,
      'flag': flag,
    };
  }
}
