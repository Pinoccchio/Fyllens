import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

/// Sign out use case
/// Single responsibility: Sign out current user
@injectable
class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  /// Execute sign out
  Future<void> execute() {
    return _repository.signOut();
  }
}
