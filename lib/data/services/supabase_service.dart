import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fyllens/core/config/supabase_config.dart';

/// Supabase service singleton
/// Provides access to Supabase client throughout the app
@singleton
class SupabaseService {
  static SupabaseClient? _client;

  /// Initialize Supabase - MUST be called before configureDependencies()
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  /// Get Supabase client
  SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  /// Get auth client
  GoTrueClient get auth => client.auth;

  /// Get database client
  SupabaseQueryBuilder from(String table) => client.from(table);

  /// Get storage client
  SupabaseStorageClient get storage => client.storage;
}
