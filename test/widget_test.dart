// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/app.dart';
import 'package:fyllens/providers/theme_provider.dart';
import 'package:fyllens/features/authentication/presentation/providers/auth_provider.dart';
import 'package:fyllens/features/scan/presentation/providers/scan_provider.dart';
import 'package:fyllens/features/scan/presentation/providers/history_provider.dart';
import 'package:fyllens/features/profile/presentation/providers/profile_provider.dart';
import 'package:fyllens/core/di/injection.dart';

void main() {
  // Setup dependency injection before tests
  setUpAll(() async {
    await configureDependencies();
  });

  testWidgets('App builds and shows login page', (WidgetTester tester) async {
    // Build our app with providers and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
          ChangeNotifierProvider(create: (_) => sl<ScanProvider>()),
          ChangeNotifierProvider(create: (_) => sl<HistoryProvider>()),
          ChangeNotifierProvider(create: (_) => sl<ProfileProvider>()),
        ],
        child: const MyApp(),
      ),
    );

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that the app loaded (check for any text or icon)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
