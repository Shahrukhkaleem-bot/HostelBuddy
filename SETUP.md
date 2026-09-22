# HostelBuddy Flutter - Setup Guide

## Prerequisites

- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- Android Studio / Xcode (for emulator/device)
- Git

## Installation Steps

### 1. Clone/Setup Project

```bash
cd HostelBuddy
flutter pub get
```

### 2. Install Dependencies

All dependencies are in `pubspec.yaml`:

```bash
flutter pub upgrade
```

### 3. Run the App

**On Android/iOS Emulator:**
```bash
flutter run
```

**On Specific Device:**
```bash
flutter run -d <device_id>
```

**Get Device IDs:**
```bash
flutter devices
```

### 4. Build APK (Android)

```bash
flutter build apk --release
```

Output: `build/app/outputs/apk/release/app-release.apk`

### 5. Build iOS

```bash
flutter build ios --release
```

## Project Structure Explanation

### `/lib/core`
**Purpose**: Design system & constants

- `constants.dart` - All colors, spacing, typography, shadows
- Used globally across the app
- Single source of truth for design tokens

### `/lib/models`
**Purpose**: Data structures & dummy data

- `models.dart` - BidData, MatchData, LeadData classes
- DummyData class with sample bids, matches, leads
- Ready for backend API integration

### `/lib/screens`
**Purpose**: Full-page views

- Each screen is a StatefulWidget or StatelessWidget
- Screens handle their own state & navigation
- Named routes connect screens in main.dart

### `/lib/widgets`
**Purpose**: Reusable UI components

- `app_button.dart` - AppButton, SmallButton, IconButton
- `app_cards.dart` - AppCard, RoleCard, BidCard, MatchCard, LeadItem
- `app_input.dart` - AppInputField, AppDropdownField
- `app_selectors.dart` - GenderPill, RoomTypeButton, AmenityCheckbox, BudgetSlider, OTPInput
- `app_widgets.dart` - PageHeader, Banner, Modal, Success Animation

## Key Design Decisions

### 1. **Component-First Architecture**
- All UI is broken into reusable widgets
- Easy to maintain and update
- Consistent design across screens

### 2. **Single Constants File**
- All colors, spacing, fonts in one place
- Changes propagate automatically
- Matches CSS variable pattern from web

### 3. **Dummy Data Centralized**
- DummyData class in models.dart
- Easy to replace with API calls
- Keeps screens clean and focused

### 4. **Named Routes**
- Clean navigation in main.dart
- Type-safe argument passing
- Easy to debug navigation flow

### 5. **State Management**
- Currently using StatefulWidget
- Ready for GetX / Riverpod / BLoC migration
- No global state management needed yet

## Common Tasks

### Change Primary Color
Edit `lib/core/constants.dart`:
```dart
static const Color green = Color(0xFF00B894); // Change this
```

### Add a New Screen
1. Create `lib/screens/new_screen.dart`
2. Add route in `main.dart`
3. Import & use components from `widgets/`

### Add a New Component
1. Create in appropriate widget file
2. Follow naming convention (CamelCase, self-documenting)
3. Export from `widgets/index.dart`

### Update Dummy Data
Edit `lib/models/models.dart`:
```dart
static final List<BidData> bids = [
  // Add/modify bids here
];
```

## API Integration Checklist

- [ ] Set up API service class
- [ ] Replace DummyData with API calls in screens
- [ ] Add error handling & retry logic
- [ ] Add loading states
- [ ] Cache data locally
- [ ] Handle authentication tokens
- [ ] Add request timeout handling

## Testing

### Run Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/widgets/app_button_test.dart
```

### Generate Coverage Report
```bash
flutter test --coverage
```

## Debugging

### Enable Debug Logs
```dart
debugPrint('Your message here');
```

### Use DevTools
```bash
flutter pub global activate devtools
devtools
```

### Hot Reload
- Press `r` in terminal while app is running
- Changes reload instantly

## Performance Tips

1. Use `const` keyword for static widgets
2. Use `RepaintBoundary` for complex animations
3. Cache images & data
4. Use `ListView.builder` for long lists
5. Profile with DevTools

## Troubleshooting

### Build Issues
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

### Dependency Conflicts
```bash
flutter pub outdated
flutter pub upgrade
```

### Platform Issues
```bash
# Android
flutter clean
flutter pub cache clean
rm -rf android/.gradle

# iOS
cd ios
rm -rf Pods
rm Podfile.lock
cd ..
flutter pub get
```

## Deployment

### Google Play Store
1. Create signing key
2. Configure build.gradle
3. `flutter build appbundle`
4. Upload to Google Play Console

### Apple App Store
1. Create signing certificate
2. Configure Xcode project
3. `flutter build ios --release`
4. Upload via Xcode or Transporter

## Useful Commands

```bash
# Check dependencies
flutter pub outdated

# Analyze code
flutter analyze

# Format code
dart format lib/

# Lint code
flutter analyze --no-pub

# Check device info
flutter doctor

# Run specific device
flutter run -d <device_id>

# Build multiple architectures
flutter build apk --split-per-abi
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io/)
- [Font Awesome Icons](https://fontawesome.com/icons)

## Support

For issues or questions:
1. Check Flutter documentation
2. Search Flutter issues
3. Post on Stack Overflow
4. Check project issues

---

Happy coding! 🚀
