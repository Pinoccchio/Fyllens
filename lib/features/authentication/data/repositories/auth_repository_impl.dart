import 'package:injectable/injectable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../data/services/auth_service.dart';
import '../models/user_model.dart';

/// Authentication repository implementation (data layer)
/// Implements AuthRepository interface from domain layer
/// Handles data transformation between Supabase and domain entities
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  // MOCK MODE - Set to true when Supabase not available
  // This allows the app to run without a backend for UI testing
  static const bool _useMockAuth = true;

  AuthRepositoryImpl(this._authService);

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    if (_useMockAuth) {
      // Mock authentication - simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Return mock user for any email/password
      return const UserEntity(
        id: 'mock-user-123',
        email: 'test@example.com',
        createdAt: '2024-01-01T00:00:00.000Z',
        lastSignInAt: null,
        userMetadata: {},
      );
    }

    try {
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed: No user returned');
      }

      // Convert Supabase User to UserEntity via UserModel
      return UserModel.fromSupabaseUser(response.user!);
    } catch (e) {
      // Re-throw with more context
      throw Exception('Sign in error: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
  }) async {
    if (_useMockAuth) {
      // Mock authentication - simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Return mock user for registration
      return UserEntity(
        id: 'mock-user-new-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        createdAt: DateTime.now().toIso8601String(),
        lastSignInAt: DateTime.now().toIso8601String(),
        userMetadata: const {},
      );
    }

    try {
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign up failed: No user returned');
      }

      // Convert Supabase User to UserEntity via UserModel
      return UserModel.fromSupabaseUser(response.user!);
    } catch (e) {
      throw Exception('Sign up error: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    if (_useMockAuth) {
      // Mock sign out - just simulate delay
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }

    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Sign out error: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    if (_useMockAuth) {
      // Mock password reset - simulate delay
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await _authService.resetPassword(email: email);
    } catch (e) {
      throw Exception('Password reset error: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    if (_useMockAuth) {
      // Return null (no user logged in) for mock mode
      // This allows proper navigation flow
      return null;
    }

    try {
      final user = _authService.currentUser;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    } catch (e) {
      throw Exception('Get current user error: ${e.toString()}');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    if (_useMockAuth) {
      // Always return false in mock mode
      // This ensures users see login/register screens
      return false;
    }

    return _authService.isAuthenticated;
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    if (_useMockAuth) {
      // Return empty stream in mock mode
      return Stream.value(null);
    }

    return _authService.authStateChanges.map((authState) {
      final user = authState.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    });
  }
}
