import '../entities/user_entity.dart';

/// Authentication repository interface (domain layer)
/// Defines contracts for authentication operations
/// Implementation will be in data layer
abstract class AuthRepository {
  /// Sign in with email and password
  /// Returns UserEntity on success, throws exception on failure
  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  /// Returns UserEntity on success, throws exception on failure
  Future<UserEntity> signUp({
    required String email,
    required String password,
  });

  /// Sign out current user
  Future<void> signOut();

  /// Reset password for email
  Future<void> resetPassword({required String email});

  /// Get current authenticated user
  /// Returns null if not authenticated
  Future<UserEntity?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Stream of auth state changes
  /// Emits UserEntity when user signs in/out
  Stream<UserEntity?> get authStateChanges;
}
