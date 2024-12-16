<p align="center">
  <a href="https://www.verblaze.com/">
    <img src="https://www.verblaze.com/logo.svg" alt="Verblaze Logo" width="200"/>
  </a>
</p>

# Verblaze Flutter

Verblaze Flutter is a lightweight and effective multilingual (i18n) solution for Flutter applications.

## Features

- 🚀 Simple and easy-to-use API
- 💾 Built-in cache support
- ⚡ High-performance translation processing
- 🔄 Dynamic language switching
- 📱 Optimized for Flutter applications

## Installation

Add this dependency to your pubspec.yaml file:

```yaml
dependencies:
  verblaze_flutter: ^1.1.1
```

## Usage

1. Initialize Verblaze:

```dart
await Verblaze.initialize(
  defaultLanguage: 'en',
  supportedLanguages: ['en', 'es', 'fr'],
);
```

2. Use translations:

```dart
// Using string extension
Text('hello'.tr()); // or
Text('hello'.translate());

// Directly
Text(Verblaze.translate('hello'));
```

3. Change language:

```dart
await Verblaze.changeLanguage('fr');
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Release Notes

See [CHANGELOG.md](CHANGELOG.md) for changes.
