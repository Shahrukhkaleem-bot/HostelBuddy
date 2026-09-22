import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_input.dart';
import '../widgets/app_selectors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String selectedRole = 'resident';
  String selectedGender = 'male';
  final phoneController = TextEditingController();
  int otpTimer = 45;
  bool showResendButton = false;
  late final List<TextEditingController> otpControllers;
  Timer? _otpTicker;

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(6, (_) => TextEditingController());
    phoneController.text = '0345-1234567';
    _startOtpTimer();
    _prefillOtp();
  }

  @override
  void dispose() {
    _otpTicker?.cancel();
    phoneController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startOtpTimer() {
    // Plain assignments: this also runs from initState, where setState
    // isn't allowed. Callers after the first build wrap it in setState.
    _otpTicker?.cancel();
    otpTimer = 45;
    showResendButton = false;
    _otpTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        otpTimer--;
        if (otpTimer <= 0) {
          showResendButton = true;
          timer.cancel();
        }
      });
    });
  }

  void _prefillOtp() {
    final codes = ['4', '8', '2', '9', '3', '7'];
    for (int i = 0; i < otpControllers.length; i++) {
      otpControllers[i].text = codes[i];
    }
  }

  void _continueOnboarding() async {
    if (selectedRole.isEmpty || selectedGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select role and gender')),
      );
      return;
    }

    // Show loading state
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    if (selectedRole == 'resident') {
      Navigator.pushReplacementNamed(context, '/resident-home');
    } else {
      Navigator.pushReplacementNamed(context, '/warden-home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space5,
            vertical: AppSpacing.space4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo & Title
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [AppShadows.sm],
                ),
                child: const Center(
                  child: Icon(
                    FontAwesomeIcons.building,
                    size: 48,
                    color: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space3),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hostel',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_2xl,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    TextSpan(
                      text: 'Buddy',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_2xl,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.space1),
              const Text(
                "Pakistan's trusted hostel marketplace",
                style: TextStyle(
                  fontSize: AppTypography.fontSize_sm,
                  color: AppColors.gray500,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: AppSpacing.space5),

              // OTP Card
              AppCard(
                elevated: true,
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          FontAwesomeIcons.phone,
                          size: 16,
                          color: AppColors.navy,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Sign in with OTP',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppTypography.fontSize_base,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    const Text(
                      'Enter your phone number to receive a 6-digit code',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        color: AppColors.gray500,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    AppInputField(
                      placeholder: '03XX-XXXXXXX',
                      controller: phoneController,
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    // OTP Input
                    OTPInput(
                      onChanged: (_) {},
                      initialValue: '482937',
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Center(
                      child: showResendButton
                          ? GestureDetector(
                              onTap: () {
                                setState(_startOtpTimer);
                                _prefillOtp();
                              },
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppTypography.fontSize_sm,
                                  decoration: TextDecoration.underline,
                                  fontFamily: AppTypography.fontFamily,
                                ),
                              ),
                            )
                          : Text(
                              'Resend code in ${otpTimer}s',
                              style: const TextStyle(
                                color: AppColors.gray500,
                                fontSize: AppTypography.fontSize_sm,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.space4),

              // Role Selection
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'I am a...',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: AppTypography.fontSize_base,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space2),
              Row(
                children: [
                  Expanded(
                    child: RoleCard(
                      label: 'Student',
                      subLabel: 'Looking for a hostel',
                      icon: FontAwesomeIcons.userGraduate,
                      selected: selectedRole == 'resident',
                      onTap: () => setState(() => selectedRole = 'resident'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(
                    child: RoleCard(
                      label: 'Hostel Manager',
                      subLabel: 'Managing a hostel',
                      icon: FontAwesomeIcons.hotel,
                      selected: selectedRole == 'warden',
                      onTap: () => setState(() => selectedRole = 'warden'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space4),

              // Gender Selection
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Gender ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppTypography.fontSize_base,
                          color: AppColors.gray900,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      TextSpan(
                        text: '(required)',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: AppTypography.fontSize_sm,
                          color: AppColors.gray500,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space2),
              Row(
                children: [
                  GenderPill(
                    gender: 'male',
                    selected: selectedGender == 'male',
                    onTap: () => setState(() => selectedGender = 'male'),
                  ),
                  const SizedBox(width: AppSpacing.space3),
                  GenderPill(
                    gender: 'female',
                    selected: selectedGender == 'female',
                    onTap: () => setState(() => selectedGender = 'female'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space5),

              // Continue Button
              AppButton(
                text: 'Continue',
                onPressed: _continueOnboarding,
                icon: FontAwesomeIcons.arrowRight,
              ),
              const SizedBox(height: AppSpacing.space3),
              const Text(
                '🔒 Your data is secure and private',
                style: TextStyle(
                  fontSize: AppTypography.fontSize_xs,
                  color: AppColors.gray500,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
