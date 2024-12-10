<p align="center">
  <a href="https://www.verblaze.com/">
    <img src="https://www.verblaze.com/logo.svg" alt="Verblaze Logo" width="200"/>
  </a>
</p>

# Verblaze Flutter SDK

Verblaze Flutter SDK is a powerful translation management system integration that allows you to easily manage multilingual support in your application. With this SDK, you can dynamically manage and update your translations.

## Features

- 🌍 Multi-language support
- 🚀 Easy integration
- 💾 Automatic caching
- 🔄 Automatic version control and updates
- 📱 Optimized for Flutter applications
- ⚡️ High-performance operation
- 🔌 Simple API integration

## Getting Started

### Installation

Add Verblaze Flutter SDK to your `pubspec.yaml` file:

```yaml
dependencies:
  verblaze_flutter: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### Configuration

Initialize the SDK in your application:

```dart
import 'package:verblaze_flutter/verblaze_flutter.dart';

// In your main widget's initState or at app startup
await Verblaze.configure('YOUR_API_KEY');
```

## Usage

### Simple Translation

```dart
// Using String extension
final translatedText = "home.welcome".vbt;

// Or for a specific language
final translatedText = "home.welcome".vbtWithLang('en');
```

### Changing Language

```dart
final provider = VerblazeProvider();
provider.setLanguage('en'); // Switch to English
```

### Usage in Widget Tree

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'welcome_screen.title'.vbt,
      style: TextStyle(fontSize: 24),
    );
  }
}
```

## Advanced Usage

### Listing Supported Languages

```dart
final provider = VerblazeProvider();
final languages = provider.supportedLanguages;

// List languages
for (var language in languages) {
  print('${language.name} (${language.nativeName})');
}
```

### Current Language Information

```dart
final provider = VerblazeProvider();
final currentLang = provider.currentLanguageObject;
print('Current language: ${currentLang?.nativeName}');
```

## Error Handling

The SDK throws `VerblazeException` when translation keys are not found or API communication fails:

```dart
try {
  final text = "invalid_key".vbt;
} on VerblazeException catch (e) {
  print('Translation error: ${e.message}');
}
```

## Contributing

We welcome contributions! Please follow these steps:

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Support

- Documentation: [Verblaze Documentations](https://verblaze.com/docs)
- Report issues: [GitHub Issues](https://github.com/verblaze/flutter-sdk/issues)
- Email: support@verblaze.com

## Security

If you discover a security vulnerability, please send an email to info@verblaze.com
