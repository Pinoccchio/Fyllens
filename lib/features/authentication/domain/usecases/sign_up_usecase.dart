import 'package:injectable/injectable.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Sign up use case
/// Single responsibility: Register new user with email and password
@injectable
class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  /// Execute sign up
  /// Returns UserEntity on success
  /// Throws exception on failure
  Future<UserEntity> execute({
    required String email,
    required String password,
  }) {
    return _repository.signUp(email: email, password: password);
  }
}
