import 'dart:io';
import '../entities/user_profile_entity.dart';

/// Profile repository interface (domain layer)
/// Defines contracts for profile operations
/// Implementation will be in data layer
abstract class ProfileRepository {
  /// Get user profile by user ID
  /// Returns UserProfileEntity if found, null otherwise
  Future<UserProfileEntity?> getUserProfile(String userId);

  /// Create new user profile
  /// Returns created UserProfileEntity
  Future<UserProfileEntity> createUserProfile({
    required String userId,
    required String email,
    String? displayName,
  });

  /// Update existing user profile
  /// Returns updated UserProfileEntity
  Future<UserProfileEntity> updateUserProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
  });

  /// Upload profile picture
  /// Returns URL of uploaded image
  Future<String> uploadProfilePicture({
    required String userId,
    required File imageFile,
  });

  /// Delete user profile
  Future<void> deleteUserProfile(String userId);
}
