import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_lesson_11/router/app_router.dart';
import 'package:nomadair_lesson_11/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AppRouter.isLoggedIn.value = false;
  });

  group('Lesson 11 — GoRouter Integration', () {
    testWidgets('App launches on Discover tab', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('Three tabs visible', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Discover'), findsOneWidget);
      expect(find.text('Search'),   findsOneWidget);
      expect(find.text('Trips'),    findsOneWidget);
    });

    testWidgets('Tapping destination card navigates to detail', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap the first destination card
      await tester.tap(find.text('Dubai').first);
      await tester.pumpAndSettle();

      expect(find.text('City of gold'), findsOneWidget);
    });

    testWidgets('Search tab shows search form', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      expect(find.text('Search Flights'), findsOneWidget);
    });

    testWidgets('Trips tab shows empty state', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Trips'));
      await tester.pumpAndSettle();

      expect(find.text('No trips yet'), findsOneWidget);
    });

    testWidgets('Theme toggle switches brightness', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final ctx = tester.element(find.byType(MaterialApp).first);
      expect(Theme.of(ctx).brightness, equals(Brightness.light));

      await tester.tap(find.byIcon(Icons.dark_mode).first);
      await tester.pumpAndSettle();

      expect(Theme.of(ctx).brightness, equals(Brightness.dark));
    });
  });
}
