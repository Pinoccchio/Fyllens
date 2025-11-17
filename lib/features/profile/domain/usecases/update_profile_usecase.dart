import 'package:injectable/injectable.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Update profile use case
/// Single responsibility: Update existing user profile
@injectable
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  /// Execute update profile
  /// Returns updated UserProfileEntity
  Future<UserProfileEntity> execute({
    required String userId,
    String? displayName,
    String? avatarUrl,
  }) {
    return _repository.updateUserProfile(
      userId: userId,
      displayName: displayName,
      avatarUrl: avatarUrl,
    );
  }
}
