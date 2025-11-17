import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Register module for external dependencies
/// These dependencies cannot be annotated directly (third-party packages)
@module
abstract class RegisterModule {
  /// Register SharedPreferences as preResolve (async initialization)
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
