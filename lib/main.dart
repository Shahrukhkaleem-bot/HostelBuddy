import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants.dart';
import 'screens/bids_inbox_screen.dart';
import 'screens/connected_leads_screen.dart';
import 'screens/contact_reveal_screen.dart';
import 'screens/google_auth_screen.dart';
import 'screens/hostel_details_screen.dart';
import 'screens/hostel_listings_screen.dart';
import 'screens/hostel_registration_screen.dart';
import 'screens/advanced_search_screen.dart';
import 'screens/analytics_dashboard_screen.dart';
import 'screens/edit_hostel_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/hostel_review_screen.dart';
import 'screens/manage_rooms_screen.dart';
import 'screens/manager_bids_screen.dart';
import 'screens/manager_post_bid_screen.dart';
import 'screens/student_main_screen.dart';
import 'screens/student_profile_completion_screen.dart';
import 'screens/student_quotes_screen.dart';
import 'screens/student_review_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/post_requirement_screen.dart';
import 'screens/resident_home_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/submit_bid_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/warden_dashboard_screen.dart';
import 'screens/warden_home_screen.dart';
import 'models/complete_models.dart';
import 'core/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Restores the Supabase session and profile before the first frame.
  await AuthService.initialize();
  runApp(const HostelBuddyApp());
}

class HostelBuddyApp extends StatelessWidget {
  const HostelBuddyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HostelBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: AppTypography.fontFamily,
        textTheme: GoogleFonts.interTextTheme(),
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
            fontFamily: AppTypography.fontFamily,
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/google-auth': (_) => const GoogleAuthScreen(),
        '/role-selection': (_) => const RoleSelectionScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/resident-home': (_) => const ResidentHomeScreen(),
        '/student-main': (_) => const StudentMainScreen(),
        '/warden-home': (_) => const WardenHomeScreen(),
        '/hostel-listings': (_) => const HostelListingsScreen(),
        '/advanced-search': (_) => const AdvancedSearchScreen(),
        '/hostel-details': (context) {
          final hostel =
              ModalRoute.of(context)?.settings.arguments as HostelData?;
          return HostelDetailsScreen(hostel: hostel ?? CompleteDummyData.hostels.first);
        },
        '/student-review': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is HostelData) {
            return StudentReviewScreen(hostel: args);
          }
          return StudentReviewScreen(hostel: CompleteDummyData.hostels.first);
        },
        '/hostel-review': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return HostelReviewScreen(
            studentName: args?['studentName'] ?? 'Ahmed Raza',
            hostelName: args?['hostelName'] ?? 'Al-Haram Hostel',
          );
        },
        '/hostel-registration': (_) => const HostelRegistrationScreen(),
        '/user-profile': (_) => const UserProfileScreen(),
        '/student-profile-completion': (_) =>
            const StudentProfileCompletionScreen(),
        '/favorites': (_) => const FavoritesScreen(),
        '/edit-hostel': (context) {
          final hostel =
              ModalRoute.of(context)?.settings.arguments as HostelData?;
          return EditHostelScreen(hostel: hostel ?? CompleteDummyData.hostels.first);
        },
        '/manage-rooms': (context) {
          final hostel =
              ModalRoute.of(context)?.settings.arguments as HostelData?;
          return ManageRoomsScreen(hostel: hostel ?? CompleteDummyData.hostels.first);
        },
        '/analytics-dashboard': (context) {
          final hostel =
              ModalRoute.of(context)?.settings.arguments as HostelData?;
          return AnalyticsDashboardScreen(hostel: hostel ?? CompleteDummyData.hostels.first);
        },
        '/post-requirement': (_) => const PostRequirementScreen(),
        '/bids-inbox': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return BidsInboxScreen(
            city: args?['city'] ?? 'G-11, Islamabad',
            budget: args?['budget'] ?? 35000,
            seats: args?['seats'] ?? 1,
            amenities: args?['amenities'] ?? ['ups', 'wifi'],
          );
        },
        '/student-quotes': (_) => const StudentQuotesScreen(),
        '/manager-bids': (_) => const ManagerBidsScreen(),
        '/manager-post-bid': (_) => const ManagerPostBidScreen(),
        '/warden-dashboard': (_) =>
            const WardenDashboardScreen(),
        '/submit-bid': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return SubmitBidScreen(
            studentId: args?['studentId'] ?? 'HB-2049',
            city: args?['city'] ?? 'G-11, Islamabad',
            budget: args?['budget'] ?? 40000,
          );
        },
        '/connected-leads': (_) =>
            const ConnectedLeadsScreen(),
        '/contact-reveal': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return ContactRevealScreen(
            hostelName: args?['hostelName'] ?? 'Al-Haram Hostel',
            studentName: args?['studentName'] ?? 'Ahmed Raza',
            hostelPhone: args?['hostelPhone'] ?? '0312-3456789',
            studentPhone: args?['studentPhone'] ?? '0345-9876543',
            hostelManager: args?['hostelManager'] ?? 'Hassan Khan',
            hostelEmail: args?['hostelEmail'] ?? 'manager@alharam.pk',
            studentEmail: args?['studentEmail'] ?? 'ahmed.raza@email.com',
            roomType: args?['roomType'] ?? '2-Seater',
            price: args?['price'] ?? 34000,
            hostelAddress: args?['hostelAddress'] as String?,
            hostelRating: (args?['hostelRating'] as num?)?.toDouble(),
            hostelAmenities:
                (args?['hostelAmenities'] as List?)?.cast<String>(),
            studentGender: args?['studentGender'] as String?,
            studentLocation: args?['studentLocation'] as String?,
          );
        },
      },
    );
  }
}
