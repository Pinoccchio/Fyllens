import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/core/theme/app_icons.dart';

/// Main layout widget
/// Provides bottom navigation for main app screens
class MainLayout extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  const MainLayout({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabChange,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppConstants.homeLabel,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: AppConstants.libraryLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.camera),
          label: AppConstants.scanLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.history),
          label: AppConstants.historyLabel,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: AppConstants.profileLabel,
        ),
      ],
    );
  }
}
