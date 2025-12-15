import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fyllens/services/supabase_service.dart';

/// Authentication service
/// Handles all authentication operations using Supabase Auth
class AuthService {
  static AuthService? _instance;
  final SupabaseService _supabaseService;

  AuthService._() : _supabaseService = SupabaseService.instance;

  /// Get singleton instance
  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }

  /// Get current user
  User? get currentUser => _supabaseService.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Get current session
  Session? get currentSession => _supabaseService.auth.currentSession;

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabaseService.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabaseService.auth.signUp(email: email, password: password);
  }

  /// Sign out
  Future<void> signOut() async {
    await _supabaseService.auth.signOut();
  }

  /// Reset password - sends reset email with custom redirect URL
  Future<void> resetPassword({
    required String email,
    String? redirectTo,
  }) async {
    await _supabaseService.auth.resetPasswordForEmail(
      email,
      redirectTo: redirectTo,
    );
  }

  /// Update user password (used after password reset)
  Future<UserResponse> updatePassword({required String newPassword}) async {
    return await _supabaseService.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges =>
      _supabaseService.auth.onAuthStateChange;
}
