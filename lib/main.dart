import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/app.dart';
import 'package:fyllens/services/supabase_service.dart';
import 'package:fyllens/services/local_storage_service.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/profile_provider.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/history_provider.dart';
import 'package:fyllens/providers/theme_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Uncomment when ready to use backend
  // Load environment variables
  // try {
  //   await dotenv.load(fileName: ".env");
  // } catch (e) {
  //   // .env file not found, will use empty values
  //   debugPrint('Warning: .env file not found');
  // }

  // Initialize services
  // LocalStorageService must be initialized before use
  await LocalStorageService.initialize();

  // Initialize Supabase (OPTIONAL)
  // App works in MOCK MODE without Supabase for UI testing
  try {
    await SupabaseService.initialize();
    debugPrint('✅ Supabase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Supabase not available - running in MOCK AUTH mode');
    debugPrint('   Error: $e');
    // App will still run with mock authentication
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
      ],
      child: const MyApp(),
    ),
  );
}
