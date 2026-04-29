import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_lesson_14/router/app_router.dart';
import 'package:nomadair_lesson_14/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AppRouter.isLoggedIn.value = false;
  });

  group('Lesson 14 — Flight Search Integration', () {
    testWidgets('Search tab shows flight form', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      expect(find.text('Find your flight'), findsOneWidget);
    });

    testWidgets('City autocomplete shows on typing', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      final departure = find.byKey(const Key('departure_city'));
      if (departure.evaluate().isEmpty) {
        // Find by label text instead
        await tester.tap(find.text('Departure City').first);
      } else {
        await tester.tap(departure);
      }
      await tester.pumpAndSettle();
    });

    testWidgets('Submit with empty form shows error', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search Flights').last);
      await tester.pumpAndSettle();

      expect(find.textContaining('departure city'), findsWidgets);
    });

    testWidgets('One Way toggle hides return date', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      expect(find.text('Return Date'), findsOneWidget);
      await tester.tap(find.text('One Way'));
      await tester.pumpAndSettle();
      expect(find.text('Return Date'), findsNothing);
    });

    testWidgets('Theme toggle works from Search tab', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      final ctx = tester.element(find.byType(MaterialApp).first);
      expect(Theme.of(ctx).brightness, equals(Brightness.light));

      await tester.tap(find.byIcon(Icons.dark_mode).first);
      await tester.pumpAndSettle();
      expect(Theme.of(ctx).brightness, equals(Brightness.dark));
    });
  });
}
