import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fyllens/models/user.dart';
import 'package:fyllens/services/database_service.dart';
import 'package:fyllens/services/storage_service.dart';

/// Profile provider - manages user profile state
class ProfileProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  final StorageService _storageService = StorageService.instance;

  User? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  User? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasProfile => _userProfile != null;

  /// Load user profile
  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _databaseService.fetchById('user_profiles', userId);
      if (result != null) {
        _userProfile = User.fromJson(result);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create user profile
  Future<bool> createProfile({
    required String userId,
    required String email,
    String? fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profileData = {
        'id': userId,
        'email': email,
        'full_name': fullName,
        'created_at': DateTime.now().toIso8601String(),
      };

      final result = await _databaseService.insert('user_profiles', profileData);
      _userProfile = User.fromJson(result);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updateData = {
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final result = await _databaseService.update('user_profiles', userId, updateData);
      _userProfile = User.fromJson(result);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Upload profile picture
  Future<String?> uploadProfilePicture({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final path = '$userId/avatar.jpg';
      final url = await _storageService.uploadImage(
        file: imageFile,
        bucket: 'avatars',
        path: path,
      );
      return url;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _extractErrorMessage(Object error) {
    final errorStr = error.toString();
    if (errorStr.startsWith('Exception: ')) {
      return errorStr.substring(11);
    }
    return errorStr;
  }
}
