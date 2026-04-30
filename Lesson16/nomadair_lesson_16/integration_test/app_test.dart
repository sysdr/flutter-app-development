import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_lesson_16/core/services/theme_preference_service.dart';
import 'package:nomadair_lesson_16/router/app_router.dart';
import 'package:nomadair_lesson_16/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AppRouter.isLoggedIn.value = false;
  });

  group('Lesson 16 — Provider Integration', () {
    testWidgets('App launches on Discover tab', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('Search tab shows form with Provider annotation',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Provider'), findsWidgets);
    });

    testWidgets('Search → Trips → Search: Provider preserves criteria',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.text('Find your flight'), findsOneWidget);

      await tester.tap(find.text('Trips'));
      await tester.pumpAndSettle();
      expect(find.text('No trips yet'), findsOneWidget);

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.text('Find your flight'), findsOneWidget);
    });

    testWidgets('StateExplorer has Provider tab', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.bar_chart).first);
      await tester.pumpAndSettle();
      expect(find.text('Provider'), findsOneWidget);
    });

    testWidgets('Provider tab Consumer demo renders', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.bar_chart).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Provider'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Consumer'), findsWidgets);
    });

    testWidgets('Theme toggle works', (tester) async {
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
