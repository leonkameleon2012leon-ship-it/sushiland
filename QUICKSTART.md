# Quick Start Guide 🌱

## Installation

```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>
```

## Testing the Flow

1. **Welcome Screen**
   - Observe the swaying leaf animations
   - Tap "Zaczynamy" button

2. **Name Input**
   - Enter your name
   - Press Enter or tap "Dalej"

3. **Permissions**
   - Tap "Zezwól" on location card
   - Tap "Zezwól" on notifications card
   - Tap "Dalej"

4. **Plant Selection**
   - Search for plants using the search bar
   - Tap plant cards to select (multiple selection)
   - Tap "Dalej" when done

5. **Dashboard**
   - View your selected plants
   - Tap "Podlej teraz" to water a plant
   - Tap "Dodaj roślinę" to add more plants

## Package Requirements

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  permission_handler: ^11.0.1
  geolocator: ^10.1.0
```

## Platform Setup

### Android
No additional setup required. Permissions are configured in:
- `android/app/src/main/AndroidManifest.xml`

### iOS
No additional setup required. Permissions are configured in:
- `ios/Runner/Info.plist`

## Building for Release

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Key Files

- `lib/main.dart` - App entry point
- `lib/constants/app_theme.dart` - Theme and colors
- `lib/screens/onboarding/` - Onboarding flow screens
- `lib/screens/home/` - Main dashboard
- `README.md` - Full documentation
- `SCREENS.md` - Visual screen documentation
- `IMPLEMENTATION.md` - Implementation details

## Common Commands

```bash
# Clean build
flutter clean
flutter pub get

# Format code
flutter format lib/

# Analyze code
flutter analyze

# Run tests
flutter test

# Check for outdated packages
flutter pub outdated
```

## Troubleshooting

### Permission Handler Issues
If you encounter issues with permission_handler:

**iOS**: Make sure Xcode is up to date
```bash
cd ios
pod install
cd ..
```

**Android**: Make sure minSdkVersion is at least 20 in `android/app/build.gradle`

### Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Customization

### Change Colors
Edit `lib/constants/app_theme.dart`:
```dart
static const Color primaryGreen = Color(0xFF4CAF50);
static const Color lightGreen = Color(0xFF81C784);
// etc.
```

### Add More Plants
Edit `lib/screens/onboarding/plant_selection_screen.dart`:
```dart
const List<Plant> availablePlants = [
  Plant(name: 'NewPlant', emoji: '🌸', description: '...', wateringDays: 7),
  // Add more...
];
```

### Change Animation Speed
Look for `duration` parameters in screen files:
```dart
duration: const Duration(milliseconds: 600), // Adjust this
```

## Performance Tips

1. The app uses AnimationController - these are properly disposed
2. SharedPreferences is used for lightweight data storage
3. All images are vector icons (no bitmap assets to load)
4. Animations use hardware acceleration

## Next Steps

1. Test on real devices (iOS and Android)
2. Add actual plant images
3. Implement push notifications
4. Add weather API integration
5. Implement data persistence for plants
6. Add plant history/timeline
7. Add camera integration for plant photos

## Support

For Flutter issues:
- https://flutter.dev/docs
- https://github.com/flutter/flutter/issues

For package-specific issues:
- permission_handler: https://pub.dev/packages/permission_handler
- shared_preferences: https://pub.dev/packages/shared_preferences
