import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/create_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_profile_picture_usecase.dart';

/// Profile provider (presentation layer)
/// Manages user profile state using Provider pattern with Clean Architecture
@injectable
class ProfileProvider with ChangeNotifier {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final CreateProfileUseCase _createProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadProfilePictureUseCase _uploadProfilePictureUseCase;

  ProfileProvider(
    this._getUserProfileUseCase,
    this._createProfileUseCase,
    this._updateProfileUseCase,
    this._uploadProfilePictureUseCase,
  );

  // State properties
  UserProfileEntity? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserProfileEntity? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasProfile => _userProfile != null;

  /// Load user profile
  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _getUserProfileUseCase.execute(userId);
      _userProfile = profile;
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
    String? displayName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _createProfileUseCase.execute(
        userId: userId,
        email: email,
        displayName: displayName,
      );
      _userProfile = profile;
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
    String? displayName,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _updateProfileUseCase.execute(
        userId: userId,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
      _userProfile = profile;
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = await _uploadProfilePictureUseCase.execute(
        userId: userId,
        imageFile: imageFile,
      );
      _isLoading = false;
      notifyListeners();
      return url;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
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

  /// Extract user-friendly error message from exception
  String _extractErrorMessage(Object error) {
    final errorStr = error.toString();

    // Remove "Exception: " prefix if present
    if (errorStr.startsWith('Exception: ')) {
      return errorStr.substring(11);
    }

    return errorStr;
  }
}
