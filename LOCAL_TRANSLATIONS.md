# Local Translations Usage Guide

Verblaze Flutter SDK now supports local translations! You can use translation files directly from your app's assets without needing an API key.

## How It Works

The SDK automatically detects if you have local translation files in your `locales/` folder:

- **If local translations exist**: Uses local files (no API key needed)
- **If no local translations**: Falls back to remote API (API key required)

## Setup

### 1. Add Translation Files

Create a `locales/` folder in your app and add JSON files:

```
your_app/
├── locales/
│   ├── en-US.json
│   ├── tr-TR.json
│   └── fr-FR.json
└── pubspec.yaml
```

### 2. Configure Assets

Add the locales folder to your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - locales/
```

### 3. Translation File Format

Each translation file should follow this structure:

```json
{
  "language": "en-US",
  "translations": {
    "main": {
      "values": {
        "welcome": "Welcome",
        "settings": "Settings",
        "home": "Home"
      }
    },
    "settings": {
      "values": {
        "change_language": "Change Language",
        "save": "Save"
      }
    }
  }
}
```

## Usage

### With Local Translations (No API Key Needed)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // No API key needed when using local translations
  await Verblaze.configure();

  runApp(MyApp());
}
```

### With Remote API (API Key Required)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // API key required when no local translations available
  await Verblaze.configure("your-api-key");

  runApp(MyApp());
}
```

### Check Translation Source

You can check if the app is using local or remote translations:

```dart
bool isLocal = await Verblaze.isUsingLocalTranslations;
print('Using local translations: $isLocal');
```

## Translation Usage

Use translations the same way regardless of source:

```dart
// In your widgets
Text('main.welcome'.vbt)

// Or with explicit language
String text = Verblaze.translate('main.welcome', 'en-US');
```

## Benefits of Local Translations

- ✅ **No API dependency**: Works offline
- ✅ **No API key needed**: Simpler setup
- ✅ **Faster loading**: No network requests
- ✅ **Version control**: Translations in your repo
- ✅ **Easy updates**: Just update JSON files

## Migration from Remote to Local

1. Export your existing translations from the Verblaze dashboard
2. Save them as JSON files in the `locales/` folder
3. Remove the API key from `Verblaze.configure()`
4. The SDK will automatically use local files

## Error Handling

If you don't provide an API key and have no local translations:

```dart
// This will throw an exception
await Verblaze.configure(); // No API key, no local files

// Exception message:
// "API key is required when no local translations are available.
//  Either provide an API key or add translation files to the locales folder."
```
