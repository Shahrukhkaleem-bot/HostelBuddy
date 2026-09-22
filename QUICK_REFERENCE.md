# HostelBuddy - Quick Reference Guide

## 🎯 Quick Start

```bash
# 1. Get dependencies
flutter pub get

# 2. Run app
flutter run

# 3. Default screen: Onboarding
# Pre-filled: Phone 0345-1234567, OTP 482937
```

## 🗺️ Navigation Routes

| Route | Screen | Description |
|-------|--------|-------------|
| `/` | OnboardingScreen | Initial login & role selection |
| `/post-requirement` | PostRequirementScreen | Resident: Submit hostel requirement |
| `/bids-inbox` | BidsInboxScreen | Resident: View incoming bids |
| `/warden-dashboard` | WardenDashboardScreen | Warden: Dashboard with matches |
| `/submit-bid` | SubmitBidScreen | Warden: Create bid offer |
| `/connected-leads` | ConnectedLeadsScreen | Warden: View accepted students |

## 🎨 Colors

```dart
AppColors.navy          // #0F1B33 (primary)
AppColors.green         // #00B894 (success)
AppColors.gray50        // #F5F7FA (backgrounds)
AppColors.error         // #E74C3C (errors)
AppColors.warning       // #F39C12 (warnings)
```

## 📏 Spacing

```dart
AppSpacing.space1  = 4px
AppSpacing.space2  = 8px
AppSpacing.space3  = 12px
AppSpacing.space4  = 16px
AppSpacing.space5  = 20px
AppSpacing.space6  = 24px
```

## 🔘 Components Quick Usage

### Button
```dart
AppButton(
  text: 'Click me',
  onPressed: () {},
  variant: 'primary', // outline, outline-green, danger-outline
)
```

### Input
```dart
AppInputField(
  label: 'Phone',
  placeholder: '03XX-XXXXXXX',
  prefixIcon: FontAwesomeIcons.phone,
)
```

### Dropdown
```dart
AppDropdownField(
  label: 'City',
  items: DummyData.cities,
  onChanged: (city) {},
)
```

### Card
```dart
AppCard(
  elevated: true,
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)
```

### Gender Selection
```dart
GenderPill(
  gender: 'male',
  selected: selectedGender == 'male',
  onTap: () => setState(() => selectedGender = 'male'),
)
```

### Budget Slider
```dart
BudgetSlider(
  value: budget,
  min: 5000,
  max: 80000,
  onChanged: (val) => setState(() => budget = val),
)
```

### OTP Input
```dart
OTPInput(
  length: 6,
  onChanged: (otp) => print(otp),
  initialValue: '482937',
)
```

## 📊 Data Models

### BidData
```dart
BidData(
  id: 1,
  name: 'Al-Haram Hostel',
  rating: 4.8,
  price: 34000,
  roomType: '2-Seater',
  amenities: ['UPS', 'Wi-Fi'],
  note: 'Great location...',
  distance: '1.2 km',
  status: 'new', // or 'pending'
)
```

### MatchData
```dart
MatchData(
  studentId: 'HB-2049',
  gender: 'Male',
  city: 'G-11, Islamabad',
  budget: 40000,
  roomType: '2-Seater',
  amenities: ['ups', 'wifi'],
  matchScore: 92,
)
```

### LeadData
```dart
LeadData(
  id: 1,
  name: 'Ahmed Raza',
  phone: '0312-3456789',
  avatar: 'AR',
  hostel: 'Al-Haram Hostel',
  acceptedAt: '2 days ago',
)
```

## 🔄 Common Patterns

### Navigate to Screen
```dart
Navigator.pushNamed(context, '/bids-inbox', arguments: {
  'city': selectedCity,
  'budget': budget,
  'seats': selectedSeats,
  'amenities': selectedAmenities,
});
```

### Receive Arguments
```dart
final args = ModalRoute.of(context)?.settings.arguments as Map?;
final city = args?['city'] ?? 'G-11, Islamabad';
```

### Show Modal
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (context) => YourWidget(),
);
```

### Show Success
```dart
showDialog(
  context: context,
  barrierColor: Colors.transparent,
  builder: (_) => SuccessOverlay(
    title: 'Success!',
    subtitle: 'Action completed',
  ),
);
```

### Show Snackbar
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Message')),
);
```

## 💾 Dummy Data Access

```dart
// All bids
DummyData.bids

// All matches
DummyData.matches

// All leads
DummyData.leads

// All cities
DummyData.cities

// Helper functions
DummyData.formatPrice(35000)           // "PKR 35,000"
DummyData.getRoomLabel(2)              // "2-Seater"
DummyData.getAmenityLabel('ups')       // "UPS/Generator"
DummyData.getAmenityIcon('wifi')       // "📶"
```

## 🚨 Common Issues & Fixes

### Button not responding
- Check `enabled` and `isLoading` properties
- Verify `onPressed` callback is provided

### Dropdown not showing items
- Ensure `items` list is not empty
- Check `onChanged` callback

### OTP input not advancing
- Check TextInputType.number is set
- Verify controller is passed correctly

### Navigation not working
- Check route name matches in main.dart
- Verify arguments are passed correctly
- Use `Navigator.of(context)` if nested

## 📱 Screen Sizes

Designed for:
- Mobile: 390x780px (tested)
- Responsive: Works on 320px to 600px+ widths
- Orientation: Portrait only (currently)

## 🎭 Animations

```dart
AppDurations.fast   = 200ms   // Button press
AppDurations.med    = 350ms   // Screen transition
AppDurations.slow   = 500ms   // Success animation
```

## 🔗 Key File Locations

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry & routing |
| `lib/core/constants.dart` | Design tokens |
| `lib/models/models.dart` | Data classes & dummy data |
| `lib/screens/*.dart` | Screen implementations |
| `lib/widgets/*.dart` | Reusable components |

## 📋 Checklist for Backend Integration

- [ ] Create API service class
- [ ] Replace `DummyData.bids` with API call in `BidsInboxScreen`
- [ ] Replace `DummyData.matches` with API call in `WardenDashboardScreen`
- [ ] Replace `DummyData.leads` with API call in `ConnectedLeadsScreen`
- [ ] Add error handling for API failures
- [ ] Add loading states for API calls
- [ ] Implement authentication
- [ ] Add token refresh logic
- [ ] Cache data locally (optional)
- [ ] Add API timeout handling

## 🧪 Testing Commands

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific file
flutter test test/models/models_test.dart

# Run in watch mode
flutter test --watch
```

## 📚 Useful Flutter Commands

```bash
# Check dependencies
flutter pub outdated

# Analyze code
flutter analyze

# Format code
dart format lib/

# Generate code
flutter pub run build_runner build

# Clean build
flutter clean

# Check doctor
flutter doctor

# Get device list
flutter devices
```

## 🎯 Pro Tips

1. **Pre-fill values** - Update dummy data or pass initial values
2. **Add logging** - Use `debugPrint()` for debugging
3. **Use const** - Add const to constructors for performance
4. **Organize imports** - dart, package, relative
5. **Name clearly** - Variables should be self-documenting

## 🚀 Performance Tips

- ✅ Use RepaintBoundary for complex animations
- ✅ Cache image data
- ✅ Use ListView.builder for long lists
- ✅ Add keys to list items
- ✅ Profile with DevTools

## 📞 Support

- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Stack Overflow: Tag with `flutter`
- GitHub Issues: https://github.com/flutter/flutter/issues

---

**Version**: 1.0.0  
**Last Updated**: 2026-07-15  
**Flutter**: 3.0+  
**Status**: UI Complete, Ready for Backend
