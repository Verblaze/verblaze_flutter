class TranslationFile {
  final String fileTitle;
  final String fileKey;
  final Map<String, String> values;

  TranslationFile({
    required this.fileTitle,
    required this.fileKey,
    required this.values,
  });

  factory TranslationFile.fromJson(Map<String, dynamic> json) {
    return TranslationFile(
      fileTitle: json['file_title'],
      fileKey: json['file_key'],
      values: Map<String, String>.from(json['values']),
    );
  }
}
