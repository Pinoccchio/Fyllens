import 'package:flutter/foundation.dart';
import 'package:fyllens/models/user.dart';
import 'package:fyllens/services/auth_service.dart';

/// Authentication provider
/// Manages authentication state using simple Provider pattern
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  // State properties
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Initialize auth state
  /// Call this after provider is created
  Future<void> initialize() async {
    debugPrint('\n🔐 AuthProvider: Initializing...');
    try {
      final authUser = _authService.currentUser;
      if (authUser != null) {
        debugPrint('   ✅ Found existing user session: ${authUser.email}');
        debugPrint('   User ID: ${authUser.id}');
        _currentUser = User.fromAuthUser(authUser);
        notifyListeners();
      } else {
        debugPrint('   ℹ️ No existing user session found');
      }

      // Listen to auth state changes
      debugPrint('   Setting up auth state listener...');
      _authService.authStateChanges.listen((authState) {
        final user = authState.session?.user;
        if (user != null) {
          debugPrint('🔐 AuthProvider: Auth state changed - User signed in: ${user.email}');
          _currentUser = User.fromAuthUser(user);
        } else {
          debugPrint('🔐 AuthProvider: Auth state changed - User signed out');
          _currentUser = null;
        }
        notifyListeners();
      });

      debugPrint('✅ AuthProvider initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ AuthProvider: Initialization error');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    debugPrint('\n🔐 AuthProvider.signIn(): Starting sign in...');
    debugPrint('   Email: $email');
    debugPrint('   Password: ${"*" * password.length} (${password.length} characters)');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('   Calling AuthService.signInWithEmail()...');
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('✅ AuthProvider.signIn(): Sign in successful!');
        debugPrint('   User ID: ${response.user!.id}');
        debugPrint('   Email: ${response.user!.email}');
        _currentUser = User.fromAuthUser(response.user!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        debugPrint('❌ AuthProvider.signIn(): No user returned from auth service');
        throw Exception('Sign in failed: No user returned');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ AuthProvider.signIn(): Sign in FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace: $stackTrace');
      _errorMessage = _extractErrorMessage(e);
      debugPrint('   Extracted error message: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    debugPrint('\n🔐 AuthProvider.signUp(): Starting sign up...');
    debugPrint('   Email: $email');
    debugPrint('   Password: ${"*" * password.length} (${password.length} characters)');
    debugPrint('   Full Name: ${fullName ?? "(not provided)"}');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('   Calling AuthService.signUpWithEmail()...');
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('✅ AuthProvider.signUp(): Sign up successful!');
        debugPrint('   User ID: ${response.user!.id}');
        debugPrint('   Email: ${response.user!.email}');
        debugPrint('   Email confirmed: ${response.user!.emailConfirmedAt != null}');
        _currentUser = User.fromAuthUser(response.user!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        debugPrint('❌ AuthProvider.signUp(): No user returned from auth service');
        throw Exception('Sign up failed: No user returned');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ AuthProvider.signUp(): Sign up FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace: $stackTrace');
      _errorMessage = _extractErrorMessage(e);
      debugPrint('   Extracted error message: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<bool> signOut() async {
    debugPrint('\n🚪 AuthProvider.signOut(): Starting sign out...');
    if (_currentUser != null) {
      debugPrint('   Current user: ${_currentUser!.email}');
      debugPrint('   User ID: ${_currentUser!.id}');
    } else {
      debugPrint('   No current user (already signed out?)');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('   Calling AuthService.signOut()...');
      await _authService.signOut();
      debugPrint('✅ AuthProvider.signOut(): Sign out successful!');
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ AuthProvider.signOut(): Sign out FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace: $stackTrace');
      _errorMessage = _extractErrorMessage(e);
      debugPrint('   Extracted error message: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword({required String email}) async {
    debugPrint('\n🔑 AuthProvider.resetPassword(): Starting password reset...');
    debugPrint('   Email: $email');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('   Calling AuthService.resetPassword()...');
      await _authService.resetPassword(email: email);
      debugPrint('✅ AuthProvider.resetPassword(): Password reset email sent!');
      debugPrint('   User should check their email: $email');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ AuthProvider.resetPassword(): Password reset FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace: $stackTrace');
      _errorMessage = _extractErrorMessage(e);
      debugPrint('   Extracted error message: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _extractErrorMessage(Object error) {
    debugPrint('   🔍 Extracting error message from: ${error.runtimeType}');
    final errorStr = error.toString();
    debugPrint('   Raw error: $errorStr');

    if (errorStr.startsWith('Exception: ')) {
      final extracted = errorStr.substring(11);
      debugPrint('   Extracted (removed "Exception: " prefix): $extracted');
      return extracted;
    }

    debugPrint('   Returning raw error string (no extraction needed)');
    return errorStr;
  }
}
