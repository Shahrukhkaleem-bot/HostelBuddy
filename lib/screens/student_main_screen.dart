import 'package:flutter/material.dart';
import 'resident_home_screen.dart';
import 'user_profile_screen.dart';
import 'advanced_search_screen.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});
  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}
class _StudentMainScreenState extends State<StudentMainScreen> {
  int _selectedIndex = 0;
  // Index 2 is the "Switch role" action, not a tab, so nothing is built for it.
  final _screens = const [
    ResidentHomeScreen(), AdvancedSearchScreen(), SizedBox.shrink(), UserProfileScreen(),
  ];
  static const _switchRoleIndex = 2;

  void _onDestinationSelected(int index) {
    if (index == _switchRoleIndex) {
      Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (_) => false);
      return;
    }
    setState(() => _selectedIndex = index);
  }
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: _selectedIndex == 0,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop && _selectedIndex != 0) setState(() => _selectedIndex = 0);
    },
    child: Scaffold(
      body: IndexedStack(index: _selectedIndex, children: [
        for (var i = 0; i < _screens.length; i++)
          TickerMode(enabled: i == _selectedIndex, child: _screens[i]),
      ]),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Post a requirement',
        onPressed: () => Navigator.pushNamed(context, '/post-requirement'),
        child: const Icon(Icons.add)),
      bottomNavigationBar: NavigationBar(selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.switch_account_outlined), label: 'Switch role'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ]),
    ),
  );
}
