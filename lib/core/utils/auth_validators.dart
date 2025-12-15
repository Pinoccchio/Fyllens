/// Authentication form validation utilities
///
/// Provides reusable validators for auth screens (login, register, forgot password, etc.)
/// All validators return null for valid input, or an error message string for invalid input.
///
/// Usage:
/// ```dart
/// TextFormField(
///   validator: (value) => validateEmail(value),
///   // ... other properties
/// )
/// ```
class AuthValidators {
  /// Validate email address format
  ///
  /// Checks:
  /// - Not null or empty
  /// - Matches basic email regex pattern (user@domain.tld)
  ///
  /// Returns null if valid, error message if invalid.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    // Basic email regex pattern
    // Format: user@domain.tld
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password
  ///
  /// Checks:
  /// - Not null or empty
  /// - Minimum 6 characters length
  ///
  /// Returns null if valid, error message if invalid.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validate full name
  ///
  /// Checks:
  /// - Not null or empty
  /// - Minimum 2 characters length
  ///
  /// Returns null if valid, error message if invalid.
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }

    if (value.length < 2) {
      return 'Full name must be at least 2 characters';
    }

    return null;
  }

  /// Validate confirm password (must match original password)
  ///
  /// Checks:
  /// - Not null or empty
  /// - Matches the original password exactly
  ///
  /// [value] - The confirm password value to validate
  /// [password] - The original password to match against
  ///
  /// Returns null if valid, error message if invalid.
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}
