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
    try {
      final authUser = _authService.currentUser;
      if (authUser != null) {
        _currentUser = User.fromAuthUser(authUser);
        notifyListeners();
      }

      // Listen to auth state changes
      _authService.authStateChanges.listen((authState) {
        final user = authState.session?.user;
        if (user != null) {
          _currentUser = User.fromAuthUser(user);
        } else {
          _currentUser = null;
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Auth initialization error: $e');
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _currentUser = User.fromAuthUser(response.user!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Sign in failed: No user returned');
      }
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _currentUser = User.fromAuthUser(response.user!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Sign up failed: No user returned');
      }
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<bool> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signOut();
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword({required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
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
    final errorStr = error.toString();
    if (errorStr.startsWith('Exception: ')) {
      return errorStr.substring(11);
    }
    return errorStr;
  }
}
