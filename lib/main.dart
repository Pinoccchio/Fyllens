import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/app.dart';
// import 'package:fyllens/data/services/supabase_service.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/theme_provider.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/history_provider.dart';
import 'package:fyllens/providers/profile_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Uncomment when ready to use backend
  // Load environment variables
  // try {
  //   await dotenv.load(fileName: ".env");
  // } catch (e) {
  //   // .env file not found, will use empty values
  //   print('Warning: .env file not found');
  // }

  // TODO: Uncomment when ready to use Supabase
  // Initialize Supabase (if configured)
  // try {
  //   await SupabaseService.initialize();
  // } catch (e) {
  //   print('Warning: Supabase initialization failed: $e');
  //   // App will still run, but backend features won't work
  // }

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        // Theme provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),

        // Auth provider
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),

        // Scan provider
        ChangeNotifierProvider(create: (_) => ScanProvider()),

        // History provider
        ChangeNotifierProvider(create: (_) => HistoryProvider()),

        // Profile provider
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
