import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fyllens/data/services/supabase_service.dart';

/// Authentication service
/// Handles all authentication operations using Supabase Auth
@injectable
class AuthService {
  final SupabaseService _supabaseService;

  AuthService(this._supabaseService);

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
    // TODO: Implement sign in logic
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
    // TODO: Implement sign up logic
    return await _supabaseService.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    // TODO: Implement sign out logic
    await _supabaseService.auth.signOut();
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    // TODO: Implement password reset logic
    await _supabaseService.auth.resetPasswordForEmail(email);
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => _supabaseService.auth.onAuthStateChange;
}
