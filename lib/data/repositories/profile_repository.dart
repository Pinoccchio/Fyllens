import 'package:fyllens/data/services/database_service.dart';
import 'package:fyllens/data/services/storage_service.dart';
import 'package:fyllens/data/models/user_profile_model.dart';
import 'dart:io';

/// Profile repository
/// Handles user profile operations
class ProfileRepository {
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();

  /// Get user profile
  Future<UserProfileModel?> getUserProfile(String userId) async {
    try {
      final result = await _databaseService.fetchById('user_profiles', userId);
      return result != null ? UserProfileModel.fromJson(result) : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Create user profile
  Future<UserProfileModel> createUserProfile({
    required String userId,
    required String email,
    String? displayName,
  }) async {
    try {
      final profileData = {
        'id': userId,
        'email': email,
        'display_name': displayName,
        'created_at': DateTime.now().toIso8601String(),
      };

      final result = await _databaseService.insert('user_profiles', profileData);
      return UserProfileModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  Future<UserProfileModel> updateUserProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      final updateData = {
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final result = await _databaseService.update(
        'user_profiles',
        userId,
        updateData,
      );
      return UserProfileModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  /// Upload profile picture
  Future<String> uploadProfilePicture({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final path = 'profiles/$userId/avatar.jpg';
      final url = await _storageService.uploadImage(
        file: imageFile,
        bucket: 'avatars',
        path: path,
      );
      return url;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user profile
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _databaseService.delete('user_profiles', userId);
    } catch (e) {
      rethrow;
    }
  }
}
