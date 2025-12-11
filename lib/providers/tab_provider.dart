import 'package:flutter/material.dart';

/// Tab navigation state provider
///
/// Manages the current tab index for MainScreen's bottom navigation.
/// This provider enables programmatic tab switching from anywhere in the app
/// without relying on GoRouter query parameters.
///
/// Use cases:
/// - Navigate to Scan tab from History (Rescan Plant button)
/// - Navigate to specific tab from deep links
/// - Navigate to tab after completing flows (e.g., post-auth)
///
/// Example:
/// ```dart
/// // Switch to Scan tab (index 2)
/// context.read<TabProvider>().setTab(2);
///
/// // Get current tab
/// final currentTab = context.watch<TabProvider>().currentTab;
/// ```
class TabProvider extends ChangeNotifier {
  /// Currently selected tab index
  /// 0 = Home, 1 = Library, 2 = Scan, 3 = History, 4 = Profile
  int _currentTab = 0;

  /// Get the current tab index
  int get currentTab => _currentTab;

  /// Set the active tab and notify listeners
  ///
  /// [index] must be between 0-4 (5 tabs total)
  /// Calling this will trigger MainScreen to update its IndexedStack
  void setTab(int index) {
    debugPrint('🔄 [TAB PROVIDER] setTab($index) called');
    debugPrint('   Previous tab: $_currentTab');

    if (index < 0 || index > 4) {
      debugPrint('❌ [TAB PROVIDER] Invalid tab index: $index (must be 0-4)');
      return;
    }

    if (_currentTab != index) {
      _currentTab = index;
      debugPrint('✅ [TAB PROVIDER] Tab updated to: $_currentTab');
      notifyListeners();
    } else {
      debugPrint('ℹ️  [TAB PROVIDER] Tab unchanged, already at: $_currentTab');
    }
  }

  /// Reset to home tab (index 0)
  void resetToHome() {
    setTab(0);
  }
}
