import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/screens/home/home_screen.dart';
import 'package:fyllens/screens/library/library_screen.dart';
import 'package:fyllens/screens/scan/scan_screen.dart';
import 'package:fyllens/screens/history/history_screen.dart';
import 'package:fyllens/screens/profile/profile_screen.dart';

/// Main screen with 5-tab bottom navigation
///
/// This is the main container that holds all primary app sections.
/// Uses IndexedStack to keep all pages alive - when you switch tabs,
/// the previous tab's state (scroll position, form data, etc.) is preserved.
///
/// Tabs: Home | Library | Scan | History | Profile
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// Currently selected tab (0=Home, 1=Library, 2=Scan, 3=History, 4=Profile)
  int _currentIndex = 0;

  /// All app pages in tab order
  /// IndexedStack keeps all pages in memory so switching tabs doesn't lose state
  final List<Widget> _pages = const [
    HomeScreen(),
    LibraryScreen(),
    ScanScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  /// Handle tab selection - updates UI to show selected page
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  /// Custom bottom navigation bar with 5 tabs
  ///
  /// Using custom Container instead of BottomNavigationBar for more control
  /// over styling and to support the centered scan button design.
  Widget _buildModernBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.library_books_outlined,
                activeIcon: Icons.library_books,
                label: 'Library',
              ),
              _buildCenterScanButton(),
              _buildNavItem(
                index: 3,
                icon: Icons.history,
                activeIcon: Icons.history,
                label: 'History',
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Regular navigation tab (Home, Library, History, Profile)
  ///
  /// Each tab shows an icon and label. When selected, icon becomes filled
  /// and text turns green. When not selected, icon is outlined and gray.
  Widget _buildNavItem({
    required int index, // Tab index (0-4)
    required IconData icon, // Icon when not selected (outlined)
    required IconData activeIcon, // Icon when selected (filled)
    required String label, // Tab label text
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? AppColors.primaryGreenModern
                    : Colors.grey.shade400,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primaryGreenModern
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Center scan button - visually highlighted with circular background
  ///
  /// This is the middle tab (index 2) with special styling to emphasize
  /// the camera/scan feature.
  Widget _buildCenterScanButton() {
    final isSelected = _currentIndex == 2;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(2),
        borderRadius: BorderRadius.circular(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreenModern
                    : AppColors.primaryGreenModern.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryGreenModern.withValues(alpha: 0.2),
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryGreenModern
                              .withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                Icons.camera_alt,
                color: isSelected ? Colors.white : AppColors.primaryGreenModern,
                size: 26,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Scan',
              style: TextStyle(
                fontSize: 10,
                height: 1.0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryGreenModern
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
