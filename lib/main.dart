import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/app.dart';
import 'package:fyllens/core/di/injection.dart';
import 'package:fyllens/data/services/supabase_service.dart';
import 'package:fyllens/features/authentication/presentation/providers/auth_provider.dart';
import 'package:fyllens/features/profile/presentation/providers/profile_provider.dart';
import 'package:fyllens/features/scan/presentation/providers/scan_provider.dart';
import 'package:fyllens/features/scan/presentation/providers/history_provider.dart';
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

  // Initialize Supabase BEFORE dependency injection (OPTIONAL)
  // This is required because SupabaseService needs the client to be initialized
  // App works in MOCK MODE without Supabase for UI testing
  try {
    await SupabaseService.initialize();
    debugPrint('✅ Supabase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Supabase not available - running in MOCK AUTH mode');
    debugPrint('   Error: $e');
    // App will still run with mock authentication
  }

  // Configure dependency injection
  // This must happen AFTER Supabase initialization
  await configureDependencies();

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        // Theme provider (not yet refactored - no backend dependencies)
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),

        // Auth provider (✅ Refactored with Clean Architecture + DI)
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()..initialize()),

        // Profile provider (✅ Refactored with Clean Architecture + DI)
        ChangeNotifierProvider(create: (_) => sl<ProfileProvider>()),

        // Scan provider (✅ Refactored with Clean Architecture + DI)
        ChangeNotifierProvider(create: (_) => sl<ScanProvider>()),

        // History provider (✅ Refactored with Clean Architecture + DI)
        ChangeNotifierProvider(create: (_) => sl<HistoryProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}
