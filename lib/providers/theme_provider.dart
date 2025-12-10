import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme provider
/// Manages app theme (light/dark mode)
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  SharedPreferences? _preferences;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Storage key
  static const String _keyThemeMode = 'theme_mode';

  /// Initialize theme from storage
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    final savedTheme = _preferences!.getString(_keyThemeMode);

    if (savedTheme != null) {
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  /// Toggle theme mode
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    // Save to storage
    await _preferences?.setString(
      _keyThemeMode,
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    // Save to storage
    await _preferences?.setString(
      _keyThemeMode,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }
}
