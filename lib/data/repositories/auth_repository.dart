import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fyllens/data/services/auth_service.dart';

/// Authentication repository
/// Handles authentication business logic
class AuthRepository {
  final AuthService _authService = AuthService();

  /// Sign in with email and password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _authService.resetPassword(email: email);
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _authService.currentUser;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _authService.isAuthenticated;
  }

  /// Get auth state changes stream
  Stream<AuthState> get authStateChanges => _authService.authStateChanges;
}
