import 'package:flutter/material.dart';
import 'package:fyllens/data/services/local_storage_service.dart';

/// Theme provider
/// Manages app theme (light/dark mode)
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  LocalStorageService? _storageService;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Initialize theme from storage
  Future<void> initialize() async {
    _storageService = await LocalStorageService.getInstance();
    final savedTheme = _storageService!.getString(LocalStorageService.keyThemeMode);

    if (savedTheme != null) {
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  /// Toggle theme mode
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Save to storage
    await _storageService?.saveString(
      LocalStorageService.keyThemeMode,
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    // Save to storage
    await _storageService?.saveString(
      LocalStorageService.keyThemeMode,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }
}
