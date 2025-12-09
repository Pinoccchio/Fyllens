import 'package:shared_preferences/shared_preferences.dart';

/// Local storage service
/// Handles local data persistence using SharedPreferences
class LocalStorageService {
  static LocalStorageService? _instance;
  late final SharedPreferences _preferences;

  LocalStorageService._();

  /// Get singleton instance
  static LocalStorageService get instance {
    _instance ??= LocalStorageService._();
    return _instance!;
  }

  /// Initialize SharedPreferences
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    instance._preferences = prefs;
  }

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  /// Get string value
  String? getString(String key) {
    return _preferences.getString(key);
  }

  /// Save boolean value
  Future<bool> saveBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  /// Get boolean value
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  /// Save integer value
  Future<bool> saveInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  /// Get integer value
  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  /// Remove a key
  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  /// Clear all data
  Future<bool> clearAll() async {
    return await _preferences.clear();
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  // Storage keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyUserId = 'user_id';
}
