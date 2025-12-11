import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/app.dart';
import 'package:fyllens/core/config/supabase_config.dart';
import 'package:fyllens/services/supabase_service.dart';
import 'package:fyllens/services/local_storage_service.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/profile_provider.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/history_provider.dart';
import 'package:fyllens/providers/theme_provider.dart';
import 'package:fyllens/providers/tab_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: ".env");
    debugPrint('✅ Environment variables loaded from .env file');
  } catch (e) {
    debugPrint('❌ ERROR: Failed to load .env file');
    debugPrint('   Error: $e');
    debugPrint('   Make sure .env file exists in project root with:');
    debugPrint('   - SUPABASE_URL=your_url_here');
    debugPrint('   - SUPABASE_ANON_KEY=your_key_here');
  }

  // Initialize services
  // LocalStorageService must be initialized before use
  await LocalStorageService.initialize();

  // Validate Supabase configuration before initializing
  if (!SupabaseConfig.validate()) {
    debugPrint('❌ Supabase configuration validation failed');
    debugPrint('   App will not be able to authenticate or access database');
  }

  // Initialize Supabase
  debugPrint('\n🔧 Initializing Supabase...');
  try {
    await SupabaseService.initialize();
    debugPrint('✅ Supabase initialized successfully');
    // Log partial URL for verification (don't expose full URL in logs)
    final url = SupabaseConfig.supabaseUrl;
    if (url.isNotEmpty && url.length > 30) {
      debugPrint(
        '   URL: ${url.substring(0, 30)}...${url.substring(url.length - 10)}',
      );
    }
  } catch (e, stackTrace) {
    debugPrint('❌ CRITICAL ERROR: Supabase initialization FAILED');
    debugPrint('   Error: $e');
    debugPrint('   Type: ${e.runtimeType}');
    debugPrint('   Stack trace:');
    debugPrint('$stackTrace');
    debugPrint('\n   🔍 Troubleshooting:');
    debugPrint('   1. Check that .env file exists');
    debugPrint('   2. Verify SUPABASE_URL and SUPABASE_ANON_KEY are set');
    debugPrint('   3. Ensure values are not empty strings');
    debugPrint('   4. Check Supabase project is running');
    debugPrint('');
    // App will fail when trying to authenticate - this is expected
  }

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        // Theme provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),

        // Auth provider
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),

        // Profile provider
        ChangeNotifierProvider(create: (_) => ProfileProvider()),

        // Scan provider
        ChangeNotifierProvider(create: (_) => ScanProvider()),

        // History provider
        ChangeNotifierProvider(create: (_) => HistoryProvider()),

        // Tab navigation provider
        ChangeNotifierProvider(create: (_) => TabProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
