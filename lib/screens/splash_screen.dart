import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/auth_service.dart';
import '../core/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleController.forward();
    _fadeController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, _firstRoute());
    });
  }

  /// Signed-out users sign in; signed-in users go straight to their home.
  String _firstRoute() {
    final auth = AuthService.instance;
    if (!auth.isSignedIn) return '/google-auth';
    final role = auth.role;
    if (role == null) return '/role-selection';
    return role == 'student' ? '/student-main' : '/warden-home';
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo Container
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.3, end: 1).animate(
                        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
                      ),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.green,
                              AppColors.green.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.green.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background Icons (decorative)
                            Positioned(
                              top: 15,
                              left: 15,
                              child: Icon(
                                FontAwesomeIcons.doorOpen,
                                size: 28,
                                color: AppColors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              right: 15,
                              child: Icon(
                                FontAwesomeIcons.users,
                                size: 28,
                                color: AppColors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            // Main Building Icon
                            const Icon(
                              FontAwesomeIcons.buildingCircleArrowRight,
                              size: 70,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space6),

                    // Brand Name with Animation
                    FadeTransition(
                      opacity: _fadeController,
                      child: Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Hostel',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.navy,
                                    fontFamily: AppTypography.fontFamily,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Buddy',
                                  style: TextStyle(
                                    fontSize: 36,
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
                            "Pakistan's Trusted Hostel Marketplace",
                            style: TextStyle(
                              fontSize: AppTypography.fontSize_base,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray500,
                              fontFamily: AppTypography.fontFamily,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Loading Indicator
            FadeTransition(
              opacity: _fadeController,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space5),
                child: Column(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    const Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        color: AppColors.gray500,
                        fontFamily: AppTypography.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
