import 'dart:io';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../../data/services/database_service.dart';
import '../../../../data/services/storage_service.dart';
import '../models/user_profile_model.dart';

/// Profile repository implementation (data layer)
/// Implements ProfileRepository interface from domain layer
/// Handles data transformation between Supabase and domain entities
@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final DatabaseService _databaseService;
  final StorageService _storageService;

  ProfileRepositoryImpl(
    this._databaseService,
    this._storageService,
  );

  @override
  Future<UserProfileEntity?> getUserProfile(String userId) async {
    try {
      final result = await _databaseService.fetchById('user_profiles', userId);
      if (result == null) return null;

      // Convert Map to UserEntity via UserProfileModel
      return UserProfileModel.fromJson(result);
    } catch (e) {
      throw Exception('Get user profile error: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileEntity> createUserProfile({
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

      // Convert to entity via model
      return UserProfileModel.fromJson(result);
    } catch (e) {
      throw Exception('Create user profile error: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileEntity> updateUserProfile({
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

      // Convert to entity via model
      return UserProfileModel.fromJson(result);
    } catch (e) {
      throw Exception('Update user profile error: ${e.toString()}');
    }
  }

  @override
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
      throw Exception('Upload profile picture error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _databaseService.delete('user_profiles', userId);
    } catch (e) {
      throw Exception('Delete user profile error: ${e.toString()}');
    }
  }
}
