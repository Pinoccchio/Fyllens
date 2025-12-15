import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/screens/home/home_screen.dart';
import 'package:fyllens/screens/library/library_screen.dart';
import 'package:fyllens/screens/scan/scan_screen.dart';
import 'package:fyllens/screens/history/history_screen.dart';
import 'package:fyllens/screens/profile/profile_screen.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/providers/tab_provider.dart';

/// Main screen with 5-tab bottom navigation
///
/// This is the main container that holds all primary app sections.
/// Uses IndexedStack to keep all pages alive - when you switch tabs,
/// the previous tab's state (scroll position, form data, etc.) is preserved.
///
/// Tabs: Home | Library | Scan | History | Profile
class MainScreen extends StatefulWidget {
  /// Initial tab to display (0=Home, 1=Library, 2=Scan, 3=History, 4=Profile)
  final int initialTab;

  const MainScreen({super.key, this.initialTab = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// Currently selected tab (0=Home, 1=Library, 2=Scan, 3=History, 4=Profile)
  late int _currentIndex;

  /// All app pages in tab order
  /// IndexedStack keeps all pages in memory so switching tabs doesn't lose state
  final List<Widget> _pages = const [
    HomeScreen(),
    LibraryScreen(),
    ScanScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // LOG: Check initialTab parameter
    debugPrint('🏠 [MAIN SCREEN] initState() called');
    debugPrint('   widget.initialTab: ${widget.initialTab}');

    _currentIndex = widget.initialTab;

    debugPrint('   _currentIndex set to: $_currentIndex');
    debugPrint('✅ [MAIN SCREEN] initState() completed');
  }

  @override
  void didUpdateWidget(MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // LOG: Check if initialTab changed
    debugPrint('🔄 [MAIN SCREEN] didUpdateWidget() called');
    debugPrint('   oldWidget.initialTab: ${oldWidget.initialTab}');
    debugPrint('   widget.initialTab: ${widget.initialTab}');

    // Update _currentIndex if initialTab parameter changed
    if (oldWidget.initialTab != widget.initialTab) {
      debugPrint('🎯 [MAIN SCREEN] initialTab changed! Updating _currentIndex...');
      setState(() {
        _currentIndex = widget.initialTab;
      });
      // Also sync with TabProvider
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<TabProvider>().setTab(_currentIndex);
        }
      });
      debugPrint('✅ [MAIN SCREEN] _currentIndex updated to: $_currentIndex');
    } else {
      debugPrint('ℹ️  [MAIN SCREEN] initialTab unchanged, no update needed');
    }
  }

  /// Handle tab selection - updates UI to show selected page
  void _onTabTapped(int index) {
    debugPrint('🔢 [MAIN SCREEN] Tab tapped: $index');
    setState(() {
      _currentIndex = index;
      debugPrint('   _currentIndex updated to: $_currentIndex');
    });
    // Also update TabProvider so other parts of app know current tab
    context.read<TabProvider>().setTab(index);
    debugPrint('✅ [MAIN SCREEN] Tab change complete');
  }

  /// Show exit confirmation dialog
  Future<bool> _showExitConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        title: Text(
          'Exit Application',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to exit the app?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreenModern,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    ) ?? false; // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    // Watch TabProvider for programmatic tab changes from other screens
    final tabProvider = context.watch<TabProvider>();

    // Sync local state with provider if they differ
    if (tabProvider.currentTab != _currentIndex) {
      debugPrint('📡 [MAIN SCREEN] TabProvider changed: ${tabProvider.currentTab}');
      debugPrint('   Syncing _currentIndex from $_currentIndex to ${tabProvider.currentTab}');
      // Update _currentIndex without calling setState to avoid rebuild loop
      // The build will use tabProvider.currentTab directly
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _currentIndex != tabProvider.currentTab) {
          setState(() {
            _currentIndex = tabProvider.currentTab;
          });
          debugPrint('✅ [MAIN SCREEN] _currentIndex synced to: $_currentIndex');
        }
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          // Show exit confirmation dialog
          final shouldExit = await _showExitConfirmation();
          if (shouldExit) {
            // Exit the app
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(index: tabProvider.currentTab, children: _pages),
        bottomNavigationBar: _buildModernBottomNav(),
      ),
    );
  }

  /// Custom bottom navigation bar with 5 tabs
  ///
  /// Using custom Container instead of BottomNavigationBar for more control
  /// over styling and to support the centered scan button design.
  Widget _buildModernBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
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
                icon: AppIcons.home,
                activeIcon: AppIcons.homeFilled,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: AppIcons.library,
                activeIcon: AppIcons.libraryFilled,
                label: 'Library',
              ),
              _buildCenterScanButton(),
              _buildNavItem(
                index: 3,
                icon: AppIcons.history,
                activeIcon: AppIcons.historyFilled,
                label: 'History',
              ),
              _buildNavItem(
                index: 4,
                icon: AppIcons.profile,
                activeIcon: AppIcons.profileFilled,
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
                    : AppColors.textSecondary,
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
                      : AppColors.textSecondary,
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
                          color: AppColors.primaryGreenModern.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                AppIcons.camera,
                color: isSelected ? AppColors.textOnPrimary : AppColors.primaryGreenModern,
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
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
