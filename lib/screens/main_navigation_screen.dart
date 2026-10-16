import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'saved_screen.dart';
import 'reminders_screen.dart';
import 'admin_portal_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentTabIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    // If Superadmin Portal is active, show the Admin Management Screen
    if (appState.isAdminMode) {
      return const AdminPortalScreen();
    }

    final screens = [
      HomeScreen(onTabChange: _onTabChange),
      const ExploreScreen(),
      const SavedScreen(),
      RemindersScreen(onTabChange: _onTabChange),
    ];

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: IndexedStack(
              index: _currentTabIndex,
              children: screens,
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 72,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: AppColors.navShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, "Home", Icons.home_outlined, Icons.home),
                  _buildNavItem(1, "Explore", Icons.search, Icons.search),
                  _buildNavItem(2, "Saved", Icons.bookmark_border, Icons.bookmark),
                  _buildNavItem(3, "Reminders", Icons.notifications_none, Icons.notifications_active),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData inactiveIcon, IconData activeIcon) {
    final isSelected = _currentTabIndex == index;

    return InkWell(
      onTap: () => _onTabChange(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 24,
              color: isSelected ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
