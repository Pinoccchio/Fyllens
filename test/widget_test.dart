// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/app.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/history_provider.dart';
import 'package:fyllens/providers/profile_provider.dart';

void main() {
  testWidgets('App builds and shows splash screen', (WidgetTester tester) async {
    // Build our app with providers and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => ScanProvider()),
          ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that the app loaded
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
