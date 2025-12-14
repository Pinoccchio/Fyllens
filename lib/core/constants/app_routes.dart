/// Application route names
/// Centralized route definitions for navigation
class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // Auth Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main App Routes
  static const String home = '/home';
  static const String library = '/library';
  static const String scan = '/scan';
  static const String history = '/history';
  static const String profile = '/profile';

  // Scan Flow Routes
  static const String speciesSelection = '/scan/species-selection';
  static const String scanCamera = '/scan/camera';
  static const String scanResult = '/scan/result';

  // Profile Routes
  static const String editProfile = '/profile/edit';

  // Chat Routes
  static const String chat = '/chat';

  // Settings
  static const String settings = '/settings';
}
