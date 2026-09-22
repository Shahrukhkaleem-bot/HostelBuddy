import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_store.dart';
import '../core/auth_service.dart';
import '../core/constants.dart';
import '../widgets/app_button.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;
  bool isLoading = false;

  void _continue() async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    if (isLoading) return;
    setState(() => isLoading = true);
    final role = selectedRole!;
    final error = await AuthService.instance.saveRole(role);
    if (!mounted) return;
    setState(() => isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(error),
          duration: const Duration(seconds: 6),
        ));
      return;
    }

    AppStore.instance.setRole(role);
    Navigator.pushReplacementNamed(
      context,
      role == 'student' ? '/student-main' : '/hostel-registration',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space5,
              vertical: AppSpacing.space5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  // Reached via pushReplacement, so usually nothing to pop.
                  onTap: () => Navigator.canPop(context)
                      ? Navigator.pop(context)
                      : Navigator.pushReplacementNamed(context, '/google-auth'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navy.withValues(alpha: 0.04),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.arrowLeft,
                        size: 16,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space6),

                // Header
                const Text(
                  'Who are you?',
                  style: TextStyle(
                    fontSize: AppTypography.fontSize_2xl,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                    fontFamily: AppTypography.fontFamily,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.space2),
                const Text(
                  'Choose your role to get started',
                  style: TextStyle(
                    fontSize: AppTypography.fontSize_base,
                    color: AppColors.gray500,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
                const SizedBox(height: AppSpacing.space6),

                // Renter Card
                _RoleCard(
                  icon: FontAwesomeIcons.userGraduate,
                  title: 'I\'m a Renter',
                  subtitle: 'Looking for the perfect hostel',
                  selected: selectedRole == 'student',
                  onTap: () => setState(() => selectedRole = 'student'),
                  description:
                      'Browse hostels, compare prices, and connect with managers',
                ),
                const SizedBox(height: AppSpacing.space4),

                // Manager Card
                _RoleCard(
                  icon: FontAwesomeIcons.buildingCircleArrowRight,
                  title: 'I\'m a Manager',
                  subtitle: 'Managing a hostel',
                  selected: selectedRole == 'manager',
                  onTap: () => setState(() => selectedRole = 'manager'),
                  description:
                      'Find students, manage vacancies, and grow your business',
                ),
                const SizedBox(height: AppSpacing.space8),

                // Continue Button
                AppButton(
                  text: 'Continue',
                  onPressed: _continue,
                  isLoading: isLoading,
                  icon: FontAwesomeIcons.arrowRight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.all(AppSpacing.space5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? AppColors.green : AppColors.gray100,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.green.withValues(alpha: 0.1)
                  : AppColors.navy.withValues(alpha: 0.04),
              blurRadius: selected ? 12 : 8,
              offset: Offset(0, selected ? 4.0 : 2.0),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.green.withValues(alpha: 0.1)
                    : AppColors.navy.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 32,
                  color: selected ? AppColors.green : AppColors.navy,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space4),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppTypography.fontSize_lg,
                      fontWeight: FontWeight.w700,
                      color: selected ? AppColors.green : AppColors.navy,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: AppTypography.fontSize_sm,
                      color: AppColors.gray500,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: AppTypography.fontSize_xs,
                      color: AppColors.gray500,
                      fontFamily: AppTypography.fontFamily,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            // Checkmark
            if (selected)
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.check,
                    size: 14,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
