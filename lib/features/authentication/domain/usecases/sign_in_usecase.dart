import 'package:injectable/injectable.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Sign in use case
/// Single responsibility: Sign in user with email and password
@injectable
class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  /// Execute sign in
  /// Returns UserEntity on success
  /// Throws exception on failure
  Future<UserEntity> execute({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}
