import 'package:injectable/injectable.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Get user profile use case
/// Single responsibility: Retrieve user profile by ID
@injectable
class GetUserProfileUseCase {
  final ProfileRepository _repository;

  GetUserProfileUseCase(this._repository);

  /// Execute get user profile
  /// Returns UserProfileEntity if found, null otherwise
  Future<UserProfileEntity?> execute(String userId) {
    return _repository.getUserProfile(userId);
  }
}
