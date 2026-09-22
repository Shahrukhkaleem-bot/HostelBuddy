import 'package:flutter/material.dart';

import 'core/app_store.dart';
import 'core/auth_service.dart';
import 'core/constants.dart';
import 'models/complete_models.dart';
import 'widgets/marketplace_widgets.dart';
import 'screens/advanced_search_screen.dart';
import 'screens/analytics_dashboard_screen.dart';
import 'screens/bids_inbox_screen.dart';
import 'screens/connected_leads_screen.dart';
import 'screens/contact_reveal_screen.dart';
import 'screens/edit_hostel_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/google_auth_screen.dart';
import 'screens/hostel_details_screen.dart';
import 'screens/hostel_listings_screen.dart';
import 'screens/hostel_registration_screen.dart';
import 'screens/hostel_review_screen.dart';
import 'screens/manage_rooms_screen.dart';
import 'screens/manager_bids_screen.dart';
import 'screens/manager_post_bid_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/post_requirement_screen.dart';
import 'screens/resident_home_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/student_main_screen.dart';
import 'screens/student_profile_completion_screen.dart';
import 'screens/student_quotes_screen.dart';
import 'screens/student_review_screen.dart';
import 'screens/submit_bid_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/warden_dashboard_screen.dart';
import 'screens/warden_home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Demo data first: restoring it replaces the profile, so the signed-in
  // identity has to be applied after, not before.
  await AppStore.instance.initialize();
  // Restores the Supabase session and syncs the profile onto the store.
  await AuthService.initialize();
  runApp(const HostelBuddyApp());
}

/// Route argument, or null when the route was opened without a usable one.
T? _arg<T>(BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  return args is T ? args : null;
}

/// Screens that take a hostel are opened with a hostel id.
Widget _hostelRoute(BuildContext context, Widget Function(HostelData) build) {
  final hostel = AppStore.instance.hostel(_arg<int>(context));
  return hostel == null ? const UnavailableScreen() : build(hostel);
}

/// The demo data has no hostel email field, so derive one from the name.
String _demoEmail(String hostelName) {
  final slug = hostelName.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
  return 'manager@${slug.isEmpty ? 'hostel' : slug}.pk';
}

class HostelBuddyApp extends StatelessWidget {
  const HostelBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HostelBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.gray50,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: AppTypography.fontSize_lg,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/google-auth': (_) => const GoogleAuthScreen(),
        '/role-selection': (_) => const RoleSelectionScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/student-main': (_) => const StudentMainScreen(),
        '/resident-home': (_) => const ResidentHomeScreen(),
        '/warden-home': (_) => const WardenHomeScreen(),
        '/warden-dashboard': (_) => const WardenDashboardScreen(),
        '/hostel-listings': (_) => const HostelListingsScreen(),
        '/advanced-search': (_) => const AdvancedSearchScreen(),
        '/favorites': (_) => const FavoritesScreen(),
        '/post-requirement': (_) => const PostRequirementScreen(),
        '/hostel-registration': (_) => const HostelRegistrationScreen(),
        '/user-profile': (_) => const UserProfileScreen(),
        '/student-profile-completion': (_) =>
            const StudentProfileCompletionScreen(),
        '/manager-bids': (_) => const ManagerBidsScreen(),
        '/connected-leads': (_) => const ConnectedLeadsScreen(),
        '/student-quotes': (_) => const StudentQuotesScreen(),

        // Opened with a hostel id.
        '/hostel-details': (context) => _hostelRoute(
            context, (hostel) => HostelDetailsScreen(hostel: hostel)),
        '/edit-hostel': (context) =>
            _hostelRoute(context, (hostel) => EditHostelScreen(hostel: hostel)),
        '/manage-rooms': (context) =>
            _hostelRoute(context, (hostel) => ManageRoomsScreen(hostel: hostel)),
        '/analytics-dashboard': (context) => _hostelRoute(
            context, (hostel) => AnalyticsDashboardScreen(hostel: hostel)),
        '/student-review': (context) => _hostelRoute(
            context, (hostel) => StudentReviewScreen(hostel: hostel)),

        // Opened with a requirement id.
        '/bids-inbox': (context) {
          final requirementId = _arg<int>(context);
          return requirementId == null
              ? const UnavailableScreen()
              : BidsInboxScreen(requirementId: requirementId);
        },
        '/submit-bid': (context) {
          final requirementId = _arg<int>(context);
          return requirementId == null
              ? const UnavailableScreen()
              : SubmitBidScreen(requirementId: requirementId);
        },
        // Optional here: the manager can also pick a request on the screen.
        '/manager-post-bid': (context) =>
            ManagerPostBidScreen(requirementId: _arg<int>(context)),

        // Opened with a bid id, once its contact details are unlocked.
        '/contact-reveal': (context) {
          final store = AppStore.instance;
          final bid = store.bid(_arg<int>(context));
          final hostel = store.hostel(bid?.hostelId);
          if (bid == null || hostel == null || !bid.contactUnlocked) {
            return const UnavailableScreen();
          }
          final profile = store.profile;
          return ContactRevealScreen(
            hostelName: hostel.name,
            studentName: profile.name,
            hostelPhone: hostel.managerPhone,
            studentPhone: profile.phone,
            hostelManager: hostel.managerName,
            hostelEmail: _demoEmail(hostel.name),
            studentEmail: profile.email,
            roomType: bid.roomType,
            price: bid.price,
            hostelAddress: hostel.address,
            hostelRating: hostel.overallRating,
            hostelAmenities: hostel.amenities,
            studentGender: profile.gender,
            studentLocation: '${profile.city} · ${bid.roomType}',
          );
        },

        // Opened with {'studentName': ..., 'hostelName': ...}.
        '/hostel-review': (context) {
          final args = _arg<Map>(context);
          final studentName = args?['studentName'] as String?;
          final hostelName = args?['hostelName'] as String?;
          if (studentName == null || hostelName == null) {
            return const UnavailableScreen();
          }
          return HostelReviewScreen(
            studentName: studentName,
            hostelName: hostelName,
          );
        },
      },
    );
  }
}
