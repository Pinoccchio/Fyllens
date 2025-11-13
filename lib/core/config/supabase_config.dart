import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration
/// Loads Supabase credentials from environment variables
class SupabaseConfig {
  // Prevent instantiation
  SupabaseConfig._();

  /// Supabase project URL
  static String get supabaseUrl {
    return dotenv.env['SUPABASE_URL'] ?? '';
  }

  /// Supabase anonymous key
  static String get supabaseAnonKey {
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  /// Check if Supabase is configured
  static bool get isConfigured {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }
}
