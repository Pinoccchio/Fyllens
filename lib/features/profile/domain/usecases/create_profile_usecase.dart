import 'package:injectable/injectable.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Create profile use case
/// Single responsibility: Create new user profile
@injectable
class CreateProfileUseCase {
  final ProfileRepository _repository;

  CreateProfileUseCase(this._repository);

  /// Execute create profile
  /// Returns created UserProfileEntity
  Future<UserProfileEntity> execute({
    required String userId,
    required String email,
    String? displayName,
  }) {
    return _repository.createUserProfile(
      userId: userId,
      email: email,
      displayName: displayName,
    );
  }
}
