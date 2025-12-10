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
  bool _isUploading = false;
  String? _errorMessage;

  User? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;
  bool get hasProfile => _userProfile != null;

  /// Load user profile
  Future<void> loadProfile(String userId) async {
    debugPrint('\n👤 ProfileProvider.loadProfile(): Loading profile...');
    debugPrint('   User ID: $userId');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint(
        '   Calling DatabaseService.fetchById("user_profiles", "$userId")...',
      );
      final result = await _databaseService.fetchById('user_profiles', userId);

      if (result != null) {
        debugPrint(
          '✅ ProfileProvider.loadProfile(): Profile loaded successfully!',
        );
        debugPrint('   Email: ${result['email']}');
        debugPrint('   Full Name: ${result['full_name']}');
        debugPrint('   Avatar URL: ${result['avatar_url'] ?? "(none)"}');
        _userProfile = User.fromJson(result);
      } else {
        debugPrint(
          '⚠️ ProfileProvider.loadProfile(): No profile found for user ID: $userId',
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('❌ ProfileProvider.loadProfile(): Load profile FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace: $stackTrace');
      _errorMessage = _extractErrorMessage(e);
      debugPrint('   Extracted error message: $_errorMessage');
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
    debugPrint('\n💾 ProfileProvider.createProfile(): Creating profile...');
    debugPrint('   User ID: $userId');
    debugPrint('   Email: $email');
    debugPrint('   Full Name: ${fullName ?? "(not provided)"}');

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

      debugPrint('   Profile data prepared:');
      debugPrint('   ${profileData.toString()}');
      debugPrint('   Calling DatabaseService.insert("user_profiles", data)...');

      final result = await _databaseService.insert(
        'user_profiles',
        profileData,
      );

      debugPrint(
        '✅ ProfileProvider.createProfile(): Profile created successfully!',
      );
      debugPrint('   Profile ID: ${result['id']}');
      debugPrint('   Email: ${result['email']}');
      debugPrint('   Full Name: ${result['full_name']}');
      debugPrint('   Created at: ${result['created_at']}');

      _userProfile = User.fromJson(result);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ ProfileProvider.createProfile(): Create profile FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace: $stackTrace');
      _errorMessage = _extractErrorMessage(e);
      debugPrint('   Extracted error message: $_errorMessage');
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
    debugPrint('\n✏️ ProfileProvider.updateProfile(): Updating profile...');
    debugPrint('   User ID: $userId');
    debugPrint('   Full Name: ${fullName ?? "(unchanged)"}');
    debugPrint('   Avatar URL: ${avatarUrl ?? "(unchanged)"}');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updateData = {
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint('   Update data prepared:');
      debugPrint('   ${updateData.toString()}');
      debugPrint(
        '   Calling DatabaseService.update("user_profiles", "$userId", data)...',
      );

      final result = await _databaseService.update(
        'user_profiles',
        userId,
        updateData,
      );

      debugPrint(
        '✅ ProfileProvider.updateProfile(): Profile updated successfully!',
      );
      debugPrint('   Profile ID: ${result['id']}');
      debugPrint('   Email: ${result['email']}');
      debugPrint('   Full Name: ${result['full_name']}');
      debugPrint('   Avatar URL: ${result['avatar_url'] ?? "(none)"}');
      debugPrint('   Updated at: ${result['updated_at']}');

      _userProfile = User.fromJson(result);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ ProfileProvider.updateProfile(): Update profile FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace: $stackTrace');
      _errorMessage = _extractErrorMessage(e);
      debugPrint('   Extracted error message: $_errorMessage');
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
    debugPrint(
      '\n📸 ProfileProvider.uploadProfilePicture(): Uploading avatar...',
    );
    debugPrint('   User ID: $userId');
    debugPrint('   File path: ${imageFile.path}');
    debugPrint('   File size: ${imageFile.lengthSync()} bytes');

    _isUploading = true;
    notifyListeners();

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '$userId/avatar_$timestamp.jpg';
      debugPrint('   Storage path: $path');
      debugPrint('   Bucket: avatars');
      debugPrint('   Calling StorageService.uploadImage()...');

      final url = await _storageService.uploadImage(
        file: imageFile,
        bucket: 'avatars',
        path: path,
      );

      // Clean up old avatar files to prevent storage bloat
      try {
        debugPrint('   🧹 Cleaning up old avatar files...');
        final files = await _storageService.listFiles(
          bucket: 'avatars',
          path: userId,
        );

        // Delete old avatars (keep only the newly uploaded one)
        for (final file in files) {
          final fileName = file['name'] as String?;
          if (fileName != null &&
              fileName.startsWith('avatar_') &&
              fileName != path.split('/').last) {
            final oldPath = '$userId/$fileName';
            await _storageService.deleteFile(
              bucket: 'avatars',
              path: oldPath,
            );
            debugPrint('   ✅ Deleted old avatar: $fileName');
          }
        }
      } catch (e) {
        debugPrint('   ⚠️ Could not clean up old avatars: $e');
        // Non-critical error, continue anyway
      }

      debugPrint(
        '✅ ProfileProvider.uploadProfilePicture(): Upload successful!',
      );
      debugPrint('   Avatar URL: $url');
      _isUploading = false;
      notifyListeners();
      return url;
    } catch (e, stackTrace) {
      debugPrint('❌ ProfileProvider.uploadProfilePicture(): Upload FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace: $stackTrace');
      _errorMessage = _extractErrorMessage(e);
      debugPrint('   Extracted error message: $_errorMessage');
      _isUploading = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _extractErrorMessage(Object error) {
    debugPrint('   🔍 Extracting error message from: ${error.runtimeType}');
    final errorStr = error.toString();
    debugPrint('   Raw error: $errorStr');

    if (errorStr.startsWith('Exception: ')) {
      final extracted = errorStr.substring(11);
      debugPrint('   Extracted (removed "Exception: " prefix): $extracted');
      return extracted;
    }

    debugPrint('   Returning raw error string (no extraction needed)');
    return errorStr;
  }
}
