import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_lesson_09/core/services/theme_preference_service.dart';
import 'package:nomadair_lesson_09/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Lesson 09 — NomadAir Shell Integration', () {
    testWidgets('App launches with three tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Discover'), findsOneWidget);
      expect(find.text('Search'),   findsOneWidget);
      expect(find.text('Trips'),    findsOneWidget);
    });

    testWidgets('Discover tab shows destination cards', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Where to next?'), findsOneWidget);
      expect(find.text('Dubai'),          findsOneWidget);
    });

    testWidgets('Filter chips filter the destination list', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap 'Hotels' filter
      await tester.tap(find.text('Hotels'));
      await tester.pumpAndSettle();
      // Bangkok is hotels-only, should still be visible
      expect(find.text('Bangkok'), findsOneWidget);
    });

    testWidgets('Search tab shows search form', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.text('Find your flight'), findsOneWidget);
      expect(find.text('Search Flights'),   findsOneWidget);
    });

    testWidgets('Search: empty form shows inline validation errors', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search Flights'));
      await tester.pumpAndSettle();

      expect(
        find.text('Enter a departure city or code'), findsOneWidget);
      expect(
        find.text('Enter a destination city or code'), findsOneWidget);
    });

    testWidgets('Trips tab shows empty state', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('Trips'));
      await tester.pumpAndSettle();
      expect(find.text('No trips yet'),   findsOneWidget);
      expect(find.text('Start Searching'), findsOneWidget);
    });

    testWidgets('Trips: "Start Searching" navigates to Search tab', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('Trips'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Searching'));
      await tester.pumpAndSettle();

      expect(find.text('Find your flight'), findsOneWidget);
    });

    testWidgets('Theme toggle switches theme', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final ctx = tester.element(find.byType(MaterialApp));
      expect(Theme.of(ctx).brightness, equals(Brightness.light));

      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pumpAndSettle();

      expect(Theme.of(ctx).brightness, equals(Brightness.dark));
    });
  });
}
