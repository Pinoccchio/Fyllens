import 'package:injectable/injectable.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Get current user use case
/// Single responsibility: Get currently authenticated user
@injectable
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Execute get current user
  /// Returns UserEntity if authenticated, null otherwise
  Future<UserEntity?> execute() {
    return _repository.getCurrentUser();
  }
}
