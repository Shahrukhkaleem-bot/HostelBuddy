# HostelBuddy - Flutter UI

Pakistan's trusted hostel marketplace - Flutter mobile application with complete UI implementation.

## 📋 Project Structure

```
lib/
├── main.dart                          # App entry point & routing
├── core/
│   └── constants.dart                 # Design system (colors, spacing, typography)
├── models/
│   └── models.dart                    # Data models & dummy data
├── screens/
│   ├── onboarding_screen.dart        # Login & role selection
│   ├── post_requirement_screen.dart  # Resident: Post requirement
│   ├── bids_inbox_screen.dart        # Resident: View incoming bids
│   ├── warden_dashboard_screen.dart  # Warden: Dashboard & matches
│   ├── submit_bid_screen.dart        # Warden: Submit bid
│   └── connected_leads_screen.dart   # Warden: CRM & contacts
└── widgets/
    ├── app_button.dart               # Button components
    ├── app_cards.dart                # Card components (bid, match, lead)
    ├── app_input.dart                # Input fields & dropdowns
    ├── app_selectors.dart            # Selectors (gender, room type, OTP, slider)
    ├── app_widgets.dart              # Page header, banner, modal
    └── index.dart                    # Widget exports
```

## 🎨 Design System

All colors, spacing, typography, and shadows are defined in `lib/core/constants.dart`:

- **Colors**: Navy, Green, Grays (50-900)
- **Spacing**: 4px to 48px increments
- **Typography**: 11px to 28px sizes
- **Shadows**: sm, md, lg, xl
- **Radius**: 8px, 12px, 16px, 20px, full

## 🚀 Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run the App

```bash
flutter run
```

### 3. Available Routes

- `/` - Onboarding (default)
- `/onboarding` - Login & role selection
- `/post-requirement` - Post a hostel requirement (Resident)
- `/bids-inbox` - View incoming bids (Resident)
- `/warden-dashboard` - Dashboard with system matches (Warden)
- `/submit-bid` - Submit offer for a student (Warden)
- `/connected-leads` - Connected student leads (Warden)

## 📱 Screens

### Resident Flow
1. **Onboarding** - OTP login, role & gender selection
2. **Post Requirement** - Select city, budget, room type, amenities
3. **Bids Inbox** - View incoming hostel bids, accept/decline

### Warden Flow
1. **Onboarding** - OTP login, role & gender selection
2. **Dashboard** - View active vacancies & system-matched students
3. **Submit Bid** - Offer a room to a matched student
4. **Connected Leads** - View & contact students who accepted your bid

## 🎯 Key Features

✅ Complete UI with dummy data
✅ Responsive design
✅ Smooth animations & transitions
✅ Role-based navigation (Resident / Warden)
✅ Form validation & error handling
✅ Success animations
✅ Bottom sheet modal for bids
✅ OTP input with auto-advance
✅ Budget slider with currency formatting
✅ Amenity selection with checkboxes
✅ Statistics cards & skeleton loading

## 🔧 Component Examples

### Buttons
```dart
AppButton(
  text: 'Continue',
  onPressed: () {},
  icon: FontAwesomeIcons.arrowRight,
  variant: 'primary', // or 'outline', 'outline-green', 'danger-outline'
  isLoading: false,
)
```

### Cards
```dart
BidCard(
  hostelName: 'Al-Haram Hostel',
  rating: 4.8,
  price: 34000,
  roomType: '2-Seater',
  amenities: ['UPS', 'Wi-Fi'],
  thumbnail: '🏨',
  statusDot: 'new',
  onTap: () {},
)
```

### Selectors
```dart
GenderPill(
  gender: 'male',
  selected: true,
  onTap: () {},
)

RoomTypeButton(
  label: '1S',
  seats: 1,
  selected: true,
  onTap: () {},
)

BudgetSlider(
  value: 35000,
  min: 5000,
  max: 80000,
  onChanged: (value) {},
)
```

### Inputs
```dart
AppInputField(
  label: 'Phone Number',
  placeholder: '03XX-XXXXXXX',
  prefixIcon: FontAwesomeIcons.phone,
  keyboardType: TextInputType.phone,
)

AppDropdownField(
  label: 'City',
  items: ['G-11, Islamabad', 'G-10, Islamabad'],
  onChanged: (value) {},
)
```

## 📊 Dummy Data

All dummy data is centralized in `lib/models/models.dart`:

- **4 Bids** - Hostel bid cards with prices, ratings, amenities
- **4 Matches** - Student matches for warden dashboard
- **4 Leads** - Connected student contacts
- **8 Cities** - Available city options

## 🔄 Navigation Flow

```
Onboarding
├── Resident Path
│   ├── Post Requirement
│   └── Bids Inbox (with modal)
└── Warden Path
    ├── Warden Dashboard
    ├── Submit Bid
    └── Connected Leads
```

## ✨ UI Features

- **Smooth Transitions**: All screen changes use slide/fade animations
- **Loading States**: Buttons show loading spinner, skeleton cards for data
- **Success Overlays**: Animated success screens after actions
- **Bottom Modals**: Bid details in draggable bottom sheet
- **Form Validation**: Input validation before submission
- **Responsive**: Adapts to different screen sizes

## 🎨 Customization

To customize colors, spacing, or fonts:

1. Edit `lib/core/constants.dart`
2. All components use CSS-like variables
3. Changes apply throughout the app

## 📦 Dependencies

- `google_fonts` - Inter font family
- `font_awesome_flutter` - Icons
- `intl` - Internationalization
- `pinput` - OTP input (ready for integration)

## 🔐 Ready for Backend Integration

- All screen state management is prepared for API calls
- Models are structured for API responses
- No hardcoded logic - easy to replace dummy data with real API calls
- Error handling patterns in place

## 📝 Notes

- Phone numbers are dummy (02,331-3456789 format for Pakistan)
- OTP is pre-filled with 482937
- All prices in PKR (Pakistan Rupees)
- Animations use standard Material curves
- Responsive to portrait orientation

## 🚀 Next Steps

1. Set up backend API
2. Replace dummy data with API calls
3. Implement authentication
4. Add push notifications
5. Implement WhatsApp integration
6. Add image uploads for hostel photos
7. Implement payment system

---

Built with ❤️ for Pakistan's hostel students and managers.
