import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/auth_service.dart';
import '../core/constants.dart';
import '../widgets/app_button.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  // Rebuilds whenever the signed-in profile changes.
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: AuthService.instance,
        builder: (context, _) => _build(context, AuthService.instance),
      );

  Widget _build(BuildContext context, AuthService auth) {
    final role = auth.role;
    final avatar = auth.avatarUrl ?? '';
    final hasPhoto = avatar.startsWith('http');

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: AppTypography.fontSize_lg,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
        // Also shown as a bottom-nav tab, where there is nothing to go back to.
        leading: !Navigator.canPop(context) ? null : GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.space3),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(AppRadius.full),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.green,
                          AppColors.green.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.green.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: hasPhoto
                        ? Image.network(
                            avatar,
                            fit: BoxFit.cover,
                            // A broken photo URL must not blank out the header.
                            errorBuilder: (_, _, _) => const Center(
                              child: Icon(FontAwesomeIcons.user,
                                  color: AppColors.white, size: 48),
                            ),
                          )
                        : Center(
                            child: avatar.isEmpty || avatar.length > 4
                                ? const Icon(FontAwesomeIcons.user,
                                    color: AppColors.white, size: 48)
                                : Text(avatar,
                                    style: const TextStyle(fontSize: 44)),
                          ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    auth.displayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: AppTypography.fontSize_2xl,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role == 'manager'
                        ? 'Manager • Hostel owner'
                        : 'Student • Looking for Hostel',
                    style: const TextStyle(
                      fontSize: AppTypography.fontSize_sm,
                      color: AppColors.gray500,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Profile Info Section
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: AppTypography.fontSize_base,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            _InfoCard(
              icon: FontAwesomeIcons.envelope,
              label: 'Email',
              value: auth.user?.email ?? 'Not added yet',
            ),
            const SizedBox(height: AppSpacing.space2),
            _InfoCard(
              icon: FontAwesomeIcons.phone,
              label: 'Phone',
              value: auth.phone ?? 'Not added yet',
            ),
            const SizedBox(height: AppSpacing.space2),
            _InfoCard(
              icon: FontAwesomeIcons.mapPin,
              label: 'City',
              value: auth.city ?? 'Not added yet',
            ),
            const SizedBox(height: AppSpacing.space6),

            // Account Section
            const Text(
              'Account',
              style: TextStyle(
                fontSize: AppTypography.fontSize_base,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            _MenuButton(
              icon: FontAwesomeIcons.user,
              title: 'Edit Profile',
              onTap: () =>
                  Navigator.pushNamed(context, '/student-profile-completion'),
            ),
            const SizedBox(height: AppSpacing.space2),
            _MenuButton(
              icon: FontAwesomeIcons.heart,
              title: 'My Favorites',
              onTap: () => Navigator.pushNamed(context, '/favorites'),
            ),
            const SizedBox(height: AppSpacing.space2),
            _MenuButton(
              icon: FontAwesomeIcons.lock,
              title: 'Change Password',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change Password feature coming soon')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.space2),
            _MenuButton(
              icon: FontAwesomeIcons.bell,
              title: 'Notifications',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings coming soon')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.space6),

            // Help Section
            const Text(
              'Help & Support',
              style: TextStyle(
                fontSize: AppTypography.fontSize_base,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            _MenuButton(
              icon: FontAwesomeIcons.circleQuestion,
              title: 'Help Center',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help Center coming soon')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.space2),
            _MenuButton(
              icon: FontAwesomeIcons.shield,
              title: 'Privacy Policy',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy Policy coming soon')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.space6),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Logout',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final navigator = Navigator.of(context);
                            await AuthService.instance.signOut();
                            navigator.pushNamedAndRemoveUntil(
                              '/google-auth',
                              (route) => false,
                            );
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                variant: 'outline',
                icon: FontAwesomeIcons.arrowRightFromBracket,
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Center(
              child: Icon(
                icon,
                color: AppColors.navy,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppTypography.fontSize_xs,
                    color: AppColors.gray500,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppTypography.fontSize_sm,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space3,
          vertical: AppSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.gray100),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: AppColors.green,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_base,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ),
            const Icon(
              FontAwesomeIcons.chevronRight,
              size: 16,
              color: AppColors.gray300,
            ),
          ],
        ),
      ),
    );
  }
}
