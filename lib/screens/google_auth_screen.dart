import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/auth_service.dart';
import '../core/constants.dart';
import '../widgets/google_sign_in_button.dart';

class GoogleAuthScreen extends StatefulWidget {
  const GoogleAuthScreen({Key? key}) : super(key: key);

  @override
  State<GoogleAuthScreen> createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  bool isLoading = false;

  void _handleGoogleLogin() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    final auth = AuthService.instance;
    final error = await auth.signInWithGoogle();
    if (!mounted) return;
    setState(() => isLoading = false);

    // The user dismissed Google's account sheet; stay on this screen.
    if (error == AuthService.cancelled) return;
    if (error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(error),
          duration: const Duration(seconds: 6),
        ));
      return;
    }

    // Returning users skip the role question.
    final role = auth.role;
    if (role == null) {
      Navigator.pushReplacementNamed(context, '/role-selection');
      return;
    }
    Navigator.pushReplacementNamed(
      context,
      role == 'student' ? '/student-main' : '/warden-home',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space5,
              vertical: AppSpacing.space4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.space10),

                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.green.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.building,
                      size: 50,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space6),

                // Title
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hostel',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_2xl,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                          fontFamily: AppTypography.fontFamily,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: 'Buddy',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_2xl,
                          fontWeight: FontWeight.w800,
                          color: AppColors.green,
                          fontFamily: AppTypography.fontFamily,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.space2),
                const Text(
                  "Pakistan's trusted hostel marketplace",
                  style: TextStyle(
                    fontSize: AppTypography.fontSize_base,
                    color: AppColors.gray500,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
                const SizedBox(height: AppSpacing.space10),

                // Features
                Column(
                  children: [
                    _FeatureItem(
                      icon: FontAwesomeIcons.magnifyingGlass,
                      title: 'Find Perfect Hostels',
                      subtitle: 'Browse verified hostels near you',
                    ),
                    const SizedBox(height: AppSpacing.space5),
                    _FeatureItem(
                      icon: FontAwesomeIcons.handshake,
                      title: 'Connect Instantly',
                      subtitle: 'Chat directly with hostel managers',
                    ),
                    const SizedBox(height: AppSpacing.space5),
                    _FeatureItem(
                      icon: FontAwesomeIcons.star,
                      title: 'Verified & Safe',
                      subtitle: 'All hostels are verified & rated',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space10),

                // Google Sign In Button
                GoogleSignInButton(
                  onPressed: _handleGoogleLogin,
                  isLoading: isLoading,
                ),
                const SizedBox(height: AppSpacing.space4),

                // Terms
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'By signing in, you agree to our ',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_xs,
                          color: AppColors.gray500,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms of Service',
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_xs,
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_xs,
                          color: AppColors.gray500,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_xs,
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Center(
            child: Icon(
              icon,
              color: AppColors.green,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.space4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_base,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_sm,
                  color: AppColors.gray500,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
