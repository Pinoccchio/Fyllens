import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration
/// Loads Supabase credentials from environment variables
class SupabaseConfig {
  // Prevent instantiation
  SupabaseConfig._();

  /// Supabase project URL
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    if (url.isEmpty) {
      debugPrint('⚠️ WARNING: SUPABASE_URL is not set in .env file');
    }
    return url;
  }

  /// Supabase anonymous key
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    if (key.isEmpty) {
      debugPrint('⚠️ WARNING: SUPABASE_ANON_KEY is not set in .env file');
    }
    return key;
  }

  /// Check if Supabase is configured
  static bool get isConfigured {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }

  /// Validate configuration and log status
  static bool validate() {
    debugPrint('\n🔍 Validating Supabase Configuration...');

    final url = dotenv.env['SUPABASE_URL'] ?? '';
    final key = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    if (url.isEmpty) {
      debugPrint('❌ SUPABASE_URL is empty or missing');
      return false;
    }

    if (key.isEmpty) {
      debugPrint('❌ SUPABASE_ANON_KEY is empty or missing');
      return false;
    }

    if (!url.startsWith('https://')) {
      debugPrint('❌ SUPABASE_URL must start with https://');
      return false;
    }

    if (!url.contains('.supabase.co')) {
      debugPrint(
        '⚠️ WARNING: SUPABASE_URL doesn\'t contain .supabase.co (unusual)',
      );
    }

    if (key.length < 100) {
      debugPrint(
        '⚠️ WARNING: SUPABASE_ANON_KEY seems too short (expected ~200+ chars)',
      );
    }

    debugPrint('✅ Supabase configuration valid');
    debugPrint('   URL length: ${url.length} characters');
    debugPrint('   Key length: ${key.length} characters');

    return true;
  }
}
