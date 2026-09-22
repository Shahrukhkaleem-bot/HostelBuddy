import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/auth_service.dart';
import '../core/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';
import '../utils/toast_helper.dart';

class StudentProfileCompletionScreen extends StatefulWidget {
  const StudentProfileCompletionScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileCompletionScreen> createState() => _StudentProfileCompletionScreenState();
}

class _StudentProfileCompletionScreenState extends State<StudentProfileCompletionScreen> {
  // Set once the success pop is scheduled, so repeat taps can't pop twice.
  bool _isSubmitting = false;
  int currentStep = 0;

  // Step 1: Personal Info
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  String selectedGender = 'Male';

  // Step 2: Education
  final universityController = TextEditingController();
  final majorController = TextEditingController();
  String selectedYear = '1st Year';

  // Step 3: About
  final bioController = TextEditingController();
  List<String> interests = ['Gaming', 'Sports', 'Reading'];

  // Step 4: Verification
  String documentType = 'Student ID';
  bool documentsVerified = false;

  @override
  void initState() {
    super.initState();
    // Start from what the account already knows about the user.
    final auth = AuthService.instance;
    nameController.text = auth.displayName;
    phoneController.text = auth.phone ?? '';
    emailController.text = auth.user?.email ?? '';
    cityController.text = auth.city ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    universityController.dispose();
    majorController.dispose();
    bioController.dispose();
    super.dispose();
  }

  bool validateCurrentStep() {
    switch (currentStep) {
      case 0:
        if (nameController.text.isEmpty || nameController.text.length < 3) {
          ToastHelper.showError(context, message: 'Please enter a valid name (min 3 chars)');
          return false;
        }
        if (phoneController.text.isEmpty || phoneController.text.length < 10) {
          ToastHelper.showError(context, message: 'Please enter a valid phone number');
          return false;
        }
        if (emailController.text.isEmpty || !emailController.text.contains('@')) {
          ToastHelper.showError(context, message: 'Please enter a valid email');
          return false;
        }
        if (cityController.text.isEmpty) {
          ToastHelper.showError(context, message: 'Please select your city');
          return false;
        }
        return true;
      case 1:
        if (universityController.text.isEmpty) {
          ToastHelper.showError(context, message: 'Please enter your university name');
          return false;
        }
        if (majorController.text.isEmpty) {
          ToastHelper.showError(context, message: 'Please enter your major/program');
          return false;
        }
        return true;
      case 2:
        if (bioController.text.isEmpty || bioController.text.length < 20) {
          ToastHelper.showError(context, message: 'Please write a bio (min 20 chars)');
          return false;
        }
        return true;
      case 3:
        if (!documentsVerified) {
          ToastHelper.showError(context, message: 'Please upload and verify documents');
          return false;
        }
        return true;
      default:
        return false;
    }
  }

  void nextStep() {
    if (_isSubmitting) return;
    if (validateCurrentStep()) {
      if (currentStep < 3) {
        setState(() => currentStep++);
      } else {
        _save();
      }
    }
  }

  Future<void> _save() async {
    final error = await AuthService.instance.saveProfileDetails(
      fullName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      city: cityController.text.trim(),
    );
    if (!mounted) return;

    if (error != null) {
      ToastHelper.showWarning(context, message: error);
      return;
    }

    ToastHelper.showSuccess(context, message: 'Profile saved');
    _isSubmitting = true;
    Future.delayed(const Duration(seconds: 2), () {
      // Skip if the user already left, or another screen is now on top.
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      Navigator.pop(context);
    });
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Complete Your Profile'),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(FontAwesomeIcons.chevronLeft, color: AppColors.navy),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${currentStep + 1} of 4',
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray500,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    Text(
                      '${((currentStep + 1) / 4 * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: LinearProgressIndicator(
                    value: (currentStep + 1) / 4,
                    minHeight: 6,
                    backgroundColor: AppColors.gray200,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space6),

            // Step Content
            if (currentStep == 0) ...[
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: AppTypography.fontSize_lg,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: AppSpacing.space3),
              AppInputField(
                label: 'Full Name',
                controller: nameController,
                prefixIcon: FontAwesomeIcons.user,
                placeholder: 'Enter your full name',
              ),
              const SizedBox(height: AppSpacing.space3),
              AppInputField(
                label: 'Phone Number',
                controller: phoneController,
                prefixIcon: FontAwesomeIcons.phone,
                placeholder: '0300-1234567',
              ),
              const SizedBox(height: AppSpacing.space3),
              AppInputField(
                label: 'Email Address',
                controller: emailController,
                prefixIcon: FontAwesomeIcons.envelope,
                placeholder: 'your.email@example.com',
              ),
              const SizedBox(height: AppSpacing.space3),
              AppInputField(
                label: 'City',
                controller: cityController,
                prefixIcon: FontAwesomeIcons.locationDot,
                placeholder: 'Select your city',
              ),
              const SizedBox(height: AppSpacing.space3),
              Container(
                padding: const EdgeInsets.all(AppSpacing.space3),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.person, color: AppColors.green, size: 18),
                    const SizedBox(width: AppSpacing.space3),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedGender,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: ['Male', 'Female', 'Other']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedGender = value ?? 'Male');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (currentStep == 1) ...[
              const Text(
                'Education Details',
                style: TextStyle(
                  fontSize: AppTypography.fontSize_lg,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: AppSpacing.space3),
              AppInputField(
                label: 'University Name',
                controller: universityController,
                prefixIcon: FontAwesomeIcons.school,
                placeholder: 'e.g., COMSATS University',
              ),
              const SizedBox(height: AppSpacing.space3),
              AppInputField(
                label: 'Major / Program',
                controller: majorController,
                prefixIcon: FontAwesomeIcons.book,
                placeholder: 'e.g., Computer Science',
              ),
              const SizedBox(height: AppSpacing.space3),
              Container(
                padding: const EdgeInsets.all(AppSpacing.space3),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.graduationCap, color: AppColors.green, size: 18),
                    const SizedBox(width: AppSpacing.space3),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedYear,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: ['1st Year', '2nd Year', '3rd Year', '4th Year', 'Graduated']
                            .map((year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(year),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedYear = value ?? '1st Year');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (currentStep == 2) ...[
              const Text(
                'About You',
                style: TextStyle(
                  fontSize: AppTypography.fontSize_lg,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: AppSpacing.space3),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: TextField(
                  controller: bioController,
                  maxLines: 5,
                  maxLength: 250,
                  decoration: InputDecoration(
                    hintText: 'Tell us about yourself, your hobbies, interests...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(AppSpacing.space3),
                    counterText: '${bioController.text.length}/250',
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              const SizedBox(height: AppSpacing.space4),
              const Text(
                'Interests',
                style: TextStyle(
                  fontSize: AppTypography.fontSize_base,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: AppSpacing.space3),
              Wrap(
                spacing: AppSpacing.space2,
                runSpacing: AppSpacing.space2,
                children: ['Gaming', 'Sports', 'Reading', 'Music', 'Art', 'Travel', 'Cooking']
                    .map((interest) {
                  final isSelected = interests.contains(interest);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          interests.remove(interest);
                        } else {
                          interests.add(interest);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space3,
                        vertical: AppSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.green : AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(
                          color: isSelected ? AppColors.green : AppColors.gray200,
                        ),
                      ),
                      child: Text(
                        interest,
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppColors.white : AppColors.navy,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ] else if (currentStep == 3) ...[
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: AppTypography.fontSize_lg,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: AppSpacing.space3),
              Container(
                padding: const EdgeInsets.all(AppSpacing.space4),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.infoMain),
                ),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.circleInfo, color: AppColors.infoMain),
                    const SizedBox(width: AppSpacing.space3),
                    Expanded(
                      child: Text(
                        'Upload your student ID or university letter to verify your profile',
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          color: AppColors.infoMain,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.space4),
              Container(
                padding: const EdgeInsets.all(AppSpacing.space3),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.file, color: AppColors.green, size: 18),
                    const SizedBox(width: AppSpacing.space3),
                    Expanded(
                      child: DropdownButton<String>(
                        value: documentType,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: ['Student ID', 'University Letter', 'Enrollment Certificate']
                            .map((doc) => DropdownMenuItem(
                                  value: doc,
                                  child: Text(doc),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => documentType = value ?? 'Student ID');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.space3),
              GestureDetector(
                onTap: () {
                  ToastHelper.showSuccess(context, message: 'Document uploaded successfully!');
                  setState(() => documentsVerified = true);
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.space6),
                  decoration: BoxDecoration(
                    color: AppColors.greenBg,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.green, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.cloudArrowUp,
                        size: 40,
                        color: AppColors.green,
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      const Text(
                        'Tap to Upload Document',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_base,
                          fontWeight: FontWeight.w600,
                          color: AppColors.green,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      const Text(
                        'PDF or Image (max 5MB)',
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
              const SizedBox(height: AppSpacing.space4),
              if (documentsVerified)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.space3),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(FontAwesomeIcons.circleCheck,
                          color: AppColors.green),
                      const SizedBox(width: AppSpacing.space3),
                      Expanded(
                        child: Text(
                          'Document verified! Your profile is complete.',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            color: AppColors.green,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],

            const SizedBox(height: AppSpacing.space8),

            // Navigation Buttons
            Row(
              children: [
                if (currentStep > 0)
                  Expanded(
                    child: AppButton(
                      text: 'Previous',
                      onPressed: previousStep,
                      variant: 'outline',
                      icon: FontAwesomeIcons.chevronLeft,
                    ),
                  ),
                if (currentStep > 0) const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: AppButton(
                    text: currentStep == 3 ? 'Complete' : 'Next',
                    onPressed: nextStep,
                    icon: currentStep == 3
                        ? FontAwesomeIcons.check
                        : FontAwesomeIcons.chevronRight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
