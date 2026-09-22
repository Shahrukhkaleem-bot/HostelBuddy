# HostelBuddy - Architecture & Design

## System Overview

```
┌─────────────────────────────────────────┐
│         HostelBuddy Flutter App         │
├─────────────────────────────────────────┤
│  Main (Routing & Theme Configuration)   │
├─────────────────────────────────────────┤
│                 Screens                  │
│  ┌──────────────┬──────────────────┐    │
│  │   Resident   │      Warden      │    │
│  ├──────────────┼──────────────────┤    │
│  │Onboarding    │   Onboarding     │    │
│  │Post Req      │   Dashboard      │    │
│  │Bids Inbox    │   Submit Bid     │    │
│  │              │   Leads (CRM)    │    │
│  └──────────────┴──────────────────┘    │
├─────────────────────────────────────────┤
│            Reusable Widgets              │
│  Button | Card | Input | Selector       │
├─────────────────────────────────────────┤
│    Design System (Colors, Spacing)      │
├─────────────────────────────────────────┤
│       Models (Data Classes, Dummy)      │
└─────────────────────────────────────────┘
```

## Layer Breakdown

### 1. Presentation Layer (Screens)

Each screen is self-contained and responsible for:
- UI rendering
- User interaction handling
- Local state management
- Navigation

**Screens:**
- `OnboardingScreen` - Role & gender selection
- `PostRequirementScreen` - Resident requirement form
- `BidsInboxScreen` - Display incoming bids
- `WardenDashboardScreen` - Show matched students
- `SubmitBidScreen` - Create bid offer
- `ConnectedLeadsScreen` - View accepted students

### 2. Widget Layer (Components)

Reusable, composable UI components following Material Design 3:

**Button Components:**
- `AppButton` - Primary, outline, danger variants
- `SmallButton` - Compact button
- `IconButton` - Icon-only button

**Card Components:**
- `AppCard` - Base card with shadow/border
- `RoleCard` - Role selection card
- `BidCard` - Hostel bid display
- `MatchCard` - Student match display
- `LeadItem` - Contact card

**Input Components:**
- `AppInputField` - Text input with label
- `AppDropdownField` - Dropdown selector

**Selector Components:**
- `GenderPill` - Gender selection
- `RoomTypeButton` - Room type selector
- `AmenityCheckbox` - Amenity multi-select
- `BudgetSlider` - Budget range slider
- `OTPInput` - 6-digit OTP input

**Utility Widgets:**
- `PageHeader` - Navigation header with back/action buttons
- `ActiveRequestBanner` - Active requirement display
- `StatCard` - Statistics card
- `SuccessOverlay` - Success animation
- `BidModal` - Bid details bottom sheet

### 3. Data Layer (Models)

Data structures and dummy data:

```dart
class BidData {
  String name
  double rating
  int price
  String roomType
  List<String> amenities
  // ...
}

class MatchData {
  String studentId
  String city
  int budget
  List<String> amenities
  int matchScore
  // ...
}

class LeadData {
  String name
  String phone
  String avatar
  // ...
}
```

**DummyData** - Centralized test data management

### 4. Design System (Constants)

Single source of truth for visual design:

```dart
AppColors     // All color values
AppSpacing    // All spacing increments
AppRadius     // Border radius values
AppTypography // Font sizes & family
AppShadows    // Shadow definitions
AppDurations  // Animation timings
```

## Navigation Flow

### Resident User Journey

```
Onboarding
  ├─ Select Role: "Student"
  ├─ Select Gender
  └─ Continue
      └─ PostRequirement
          ├─ City Selection
          ├─ Budget Slider
          ├─ Room Type
          ├─ Amenities
          └─ Broadcast Request
              └─ BidsInbox
                  ├─ View Bids
                  ├─ Tap Bid Card
                  └─ Modal: Accept/Decline
                      └─ Success Animation
```

### Warden User Journey

```
Onboarding
  ├─ Select Role: "Manager"
  ├─ Select Gender
  └─ Continue
      └─ WardenDashboard
          ├─ View Stats
          ├─ View Matches
          └─ Tap "Bid Now"
              └─ SubmitBid
                  ├─ Fill Form
                  ├─ Set Price
                  ├─ Add Message
                  └─ Submit Bid
                      └─ Success Animation
                          └─ ConnectedLeads
                              ├─ View Accepted Students
                              └─ WhatsApp Contact
```

## State Management Pattern

### Current Approach (Stateful)

Each screen manages its own state:

```dart
class PostRequirementScreen extends StatefulWidget {
  @override
  State<PostRequirementScreen> createState() => 
    _PostRequirementScreenState();
}

class _PostRequirementScreenState extends State<PostRequirementScreen> {
  String selectedCity = 'G-11, Islamabad';
  int budget = 35000;
  int selectedSeats = 1;
  
  // UI updates via setState()
}
```

### Future State Management Options

**For medium complexity:**
```dart
// Use Provider
final budgetProvider = StateNotifier<int>((ref) => 35000);

// Use GetX
class Controller extends GetxController {
  var budget = 35000.obs;
}
```

**For complex flows:**
```dart
// Use Riverpod/BLoC for business logic
class PostRequirementBloc extends Bloc<PostRequirementEvent, PostRequirementState> {
  // Handle complex logic
}
```

## Data Flow

### Current (Dummy Data)

```
Screen
  ├─ Calls DummyData.bids
  ├─ Renders BidCard components
  ├─ User interaction
  ├─ Modal/Dialog display
  └─ Navigation
```

### After Backend Integration

```
Screen
  ├─ Call API Service
  ├─ Show Loading State
  ├─ Cache Data (optional)
  ├─ Render Components
  ├─ Handle Errors
  ├─ User Interaction
  ├─ Submit Data
  ├─ Show Success/Error
  └─ Navigate
```

## Component Props & State

### AppButton

```dart
AppButton(
  text: 'Submit',           // Display text
  onPressed: () {},         // Tap callback
  icon: FontAwesomeIcons.send,  // Optional icon
  variant: 'primary',       // primary|outline|outline-green|danger-outline
  isLoading: false,         // Show spinner
  enabled: true,            // Enable/disable
  width: double.infinity,   // Optional width
)
```

### BidCard

```dart
BidCard(
  hostelName: 'Al-Haram',
  rating: 4.8,
  price: 34000,
  roomType: '2-Seater',
  amenities: ['UPS', 'Wi-Fi'],
  thumbnail: '🏨',
  statusDot: 'new',         // new|pending
  onTap: () {},
)
```

### OTPInput

```dart
OTPInput(
  length: 6,                // Number of digits
  onChanged: (otp) {},      // OTP string callback
  initialValue: '482937',   // Pre-fill value
)
```

## Animation Timings

```dart
AppDurations.fast   = 200ms     // Quick feedback
AppDurations.med    = 350ms     // Standard transition
AppDurations.slow   = 500ms     // Dramatic effect
```

Used for:
- Button press feedback (fast)
- Screen transitions (med)
- Success animation (slow)
- Loading spinners (fast loop)

## Accessibility Considerations

Current implementation includes:
- ✅ High contrast colors (WCAG AA)
- ✅ Readable font sizes (minimum 13px)
- ✅ Sufficient touch targets (40x40px minimum)
- ✅ Semantic structure
- ✅ Icon + text labels
- ✅ Visual feedback on interaction

## Performance Optimizations

1. **Widget Reuse** - Components are composable
2. **Const Constructors** - Reduce rebuild overhead
3. **Lazy Loading** - Screens load on demand
4. **Efficient Lists** - Ready for ListView.builder
5. **Animation Performance** - GPU-accelerated transitions

## Code Quality

### Naming Conventions

- **Classes**: CamelCase (`AppButton`, `BidCard`)
- **Constants**: camelCase with AppXxx prefix
- **Private**: Underscore prefix (`_buildSkeleton()`)
- **Variables**: camelCase

### File Organization

- One main widget per file
- Import only what's needed
- Group related imports
- Use const constructors

### Documentation

- Clear variable names (self-documenting)
- Comments for non-obvious logic
- Class-level comments for complex widgets
- Inline comments for algorithms

## Testing Strategy

### Unit Tests (Models)

```dart
test('BidData formats price correctly', () {
  final bid = BidData(...);
  expect(bid.price, 34000);
});
```

### Widget Tests (Components)

```dart
testWidgets('AppButton shows loading spinner', (tester) async {
  await tester.pumpWidget(AppButton(isLoading: true));
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### Integration Tests (Flows)

```dart
testWidgets('Resident can broadcast requirement', (tester) async {
  // Test complete flow
});
```

## Future Enhancements

1. **State Management** - Migrate to Provider/Riverpod
2. **API Integration** - Connect to backend
3. **Offline Support** - Cache data locally
4. **Push Notifications** - Real-time updates
5. **Image Handling** - Upload hostel photos
6. **Payment Gateway** - Process payments
7. **Real-time Chat** - In-app messaging
8. **Analytics** - Track user behavior

---

This architecture is designed to be:
- **Scalable** - Easy to add new screens/widgets
- **Maintainable** - Clear separation of concerns
- **Testable** - Components are isolated
- **Extensible** - Ready for backend integration

