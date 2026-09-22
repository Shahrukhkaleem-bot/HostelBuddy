import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import 'resident_home_screen.dart';
import 'student_quotes_screen.dart';
import 'user_profile_screen.dart';
import 'advanced_search_screen.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({Key? key}) : super(key: key);

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const ResidentHomeScreen(),
      const AdvancedSearchScreen(),
      const StudentQuotesScreen(),
      const UserProfileScreen(),
    ];
  }

  // Index 2 is the "Switch role" action, not a tab.
  static const _switchRoleIndex = 2;

  void _onNavItemTapped(int index) {
    if (index == _switchRoleIndex) {
      Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (_) => false);
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddPressed() {
    Navigator.pushNamed(context, '/post-requirement');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.gray200, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
            top: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Home
              _buildNavItem(
                icon: FontAwesomeIcons.house,
                label: 'Home',
                index: 0,
              ),
              // Search/Discover
              _buildNavItem(
                icon: FontAwesomeIcons.magnifyingGlass,
                label: 'Search',
                index: 1,
              ),
              // Add Post (Center +)
              GestureDetector(
                onTap: _onAddPressed,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.navy.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.plus,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              // Switch role (an action, not a tab)
              _buildNavItem(
                icon: FontAwesomeIcons.rightLeft,
                label: 'Switch role',
                index: _switchRoleIndex,
              ),
              // Profile
              _buildNavItem(
                icon: FontAwesomeIcons.user,
                label: 'Profile',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.space2),
          Icon(
            icon,
            size: 24,
            color: isSelected ? AppColors.green : AppColors.gray500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.fontSize_xs,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.green : AppColors.gray500,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          const SizedBox(height: AppSpacing.space2),
          if (isSelected)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
