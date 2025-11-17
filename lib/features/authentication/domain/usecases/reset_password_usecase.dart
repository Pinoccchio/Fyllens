import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

/// Reset password use case
/// Single responsibility: Send password reset email
@injectable
class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  /// Execute password reset
  /// Sends reset email to provided address
  Future<void> execute({required String email}) {
    return _repository.resetPassword(email: email);
  }
}
