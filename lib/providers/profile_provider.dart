import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fyllens/data/repositories/profile_repository.dart';
import 'package:fyllens/data/models/user_profile_model.dart';

/// Profile provider
/// Manages user profile state
class ProfileProvider with ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();

  UserProfileModel? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfileModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasProfile => _userProfile != null;

  /// Load user profile
  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _profileRepository.getUserProfile(userId);
      _userProfile = profile;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create user profile
  Future<bool> createProfile({
    required String userId,
    required String email,
    String? displayName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _profileRepository.createUserProfile(
        userId: userId,
        email: email,
        displayName: displayName,
      );
      _userProfile = profile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _profileRepository.updateUserProfile(
        userId: userId,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
      _userProfile = profile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = await _profileRepository.uploadProfilePicture(
        userId: userId,
        imageFile: imageFile,
      );
      _isLoading = false;
      notifyListeners();
      return url;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Clear profile
  void clearProfile() {
    _userProfile = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
