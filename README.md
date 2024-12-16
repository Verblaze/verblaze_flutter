<p align="center">
  <a href="https://www.verblaze.com/">
    <img src="https://www.verblaze.com/logo.svg" alt="Verblaze Logo" width="200"/>
  </a>
</p>

# Verblaze Flutter

Verblaze Flutter is a lightweight and effective multilingual (i18n) solution for Flutter applications. It provides a simple yet powerful way to manage translations with built-in caching support and automatic language switching capabilities.

## Features

- 🚀 Simple and easy-to-use API
- 💾 Built-in cache support
- ⚡ High-performance translation processing
- 🔄 Dynamic language switching
- 📱 Optimized for Flutter applications
- 🔍 Type-safe translation keys
- 🌐 Automatic language detection
- 📦 Minimal setup required

## Installation

Add this dependency to your pubspec.yaml file:

```yaml
dependencies:
  verblaze_flutter: ^1.1.3
  provider: ^6.1.2
```

## Setup

### 1. Initialize Verblaze

First, initialize Verblaze with your API key in your app's startup:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Verblaze.configure('YOUR-API-KEY');
  runApp(const MyApp());
}
```

### 2. Setup Provider

Wrap your app with `MultiProvider` to enable language state management:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VerblazeProvider()),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
```

## Usage

### 1. Basic Translation

Use the `.vbt` extension on your translation keys:

```dart
// In any widget
Text('home_view.welcome_message'.vbt)
```

### 2. Language-Specific Translation

To get a translation for a specific language:

```dart
Text('home_view.welcome_message'.vbtWithLang('en-US'))
```

### 3. Auto-Translated Widgets

Create widgets that automatically update when language changes:

```dart
class WelcomeScreen extends AutoTranslatedWidget {
  const WelcomeScreen({super.key});

  @override
  Widget buildView(BuildContext context, VerblazeProvider provider) {
    return Column(
      children: [
        Text('welcome.title'.vbt),
        Text('welcome.description'.vbt),
      ],
    );
  }
}
```

For stateful widgets:

```dart
class MyStatefulWidget extends AutoTranslatedStatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends AutoTranslatedState<MyStatefulWidget> {
  @override
  Widget buildView(BuildContext context, VerblazeProvider provider) {
    return Column(
      children: [
        Text('my_widget.title'.vbt),
        // ... other widgets
      ],
    );
  }
}
```

### 4. Translation Key Format

Translation keys must follow the format: `file_key.translation_key`

Examples:

```dart
'home_view.welcome_message'.vbt
'settings.language_selection'.vbt
'auth.login_button'.vbt
```

### 5. Language Management

```dart
// Get current language code
final provider = VerblazeProvider();
String currentLang = provider.currentLanguage;

// Get current language object
Language? langObject = provider.currentLanguageObject;

// Get list of supported languages
List<Language> languages = provider.supportedLanguages;

// Change language
provider.setLanguage('fr-FR');
```

### 6. Error Handling

```dart
try {
  final text = 'welcome.title'.vbt;
} on VerblazeException catch (e) {
  print('Translation error: ${e.message}');
}
```

## Advanced Features

### 1. Caching

Verblaze automatically caches translations and manages version control. The cache is automatically invalidated when:

- A new version of translations is available
- The language is changed
- The app is reinstalled

### 2. Language Detection

Verblaze automatically detects and restores the last used language when the app starts.

### 3. Version Control

Verblaze maintains version control of translations and automatically updates them when new versions are available from the server.

## Example

Here's a complete example of a screen with language switching:

```dart
class SettingsScreen extends AutoTranslatedWidget {
  const SettingsScreen({super.key});

  @override
  Widget buildView(BuildContext context, VerblazeProvider provider) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings.title'.vbt),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('settings.language'.vbt),
            subtitle: Text(provider.currentLanguageObject?.generalName ?? ''),
            onTap: () => _showLanguageSelector(context),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const LanguageSelectorBottomSheet(),
    );
  }
}
```

## Best Practices

1. Always use the `AutoTranslatedWidget` for screens that contain translations
2. Follow the `file_key.translation_key` format for all translation keys
3. Handle translation errors appropriately
4. Use meaningful file keys that match your screen/component names
5. Keep translation keys lowercase and use underscores for spaces

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Release Notes

See [CHANGELOG.md](CHANGELOG.md) for changes.
