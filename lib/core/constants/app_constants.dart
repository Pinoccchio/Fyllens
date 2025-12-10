/// Application-wide constants
/// Contains string literals, configuration values, and other constants
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // App Info
  static const String appName = 'FYLLENS';
  static const String appDescription =
      'Plant Nutrient Deficiency Identification';

  // Auth Page Strings
  static const String signIn = 'Sign In';
  static const String createAccount = 'Create Account';
  static const String login = 'LOGIN';
  static const String signUp = 'SIGN UP';
  static const String register = 'REGISTER';
  static const String usernameHint = 'Username';
  static const String emailHint = 'Email';
  static const String passwordHint = 'Password';
  static const String confirmPasswordHint = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account? Register now!";
  static const String alreadyHaveAccount = 'Already have an account? Sign in!';

  // Navigation Labels
  static const String homeLabel = 'Home';
  static const String libraryLabel = 'Library';
  static const String scanLabel = 'Scan';
  static const String historyLabel = 'History';
  static const String profileLabel = 'Profile';

  // Plant Species
  static const List<String> supportedPlants = [
    'Rice',
    'Okra',
    'Eggplant',
    'Corn',
    'Cacao',
    'Banana',
    'Amplaya',
  ];

  // General Strings
  static const String comingSoon = 'Coming Soon';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'Network error. Please check your connection.';
  static const String errorAuth =
      'Authentication failed. Please check your credentials.';
}
