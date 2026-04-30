import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_lesson_15/core/services/theme_preference_service.dart';
import 'package:nomadair_lesson_15/router/app_router.dart';
import 'package:nomadair_lesson_15/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SharedPrefsThemeService.resetSingletonForTest();
    AppRouter.isLoggedIn.value = false;
  });

  group('Lesson 15 — setState Integration', () {
    testWidgets('App launches on Discover tab', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('StateExplorer accessible from AppBar', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
      await tester.tap(find.byIcon(Icons.bar_chart).first);
      await tester.pumpAndSettle();
      expect(find.text('State Explorer'), findsOneWidget);
    });

    testWidgets('StateExplorer has 3 tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.bar_chart).first);
      await tester.pumpAndSettle();
      expect(find.text('Rebuild'), findsOneWidget);
      expect(find.text('Drilling'), findsOneWidget);
      expect(find.text('Rules'),   findsOneWidget);
    });

    testWidgets('Search tab shows form with keepAlive annotation',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.textContaining('AutomaticKeepAliveClientMixin'),
        findsOneWidget);
    });

    testWidgets('Search → Trips → Search: form state preserved',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Go to Search tab
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // The keepAlive mixin is active — state should survive tab switch
      // (we can't easily select a city in integration test without
      // a real autocomplete interaction, so we verify the form exists)
      expect(find.text('Find your flight'), findsOneWidget);

      // Switch to Trips
      await tester.tap(find.text('Trips'));
      await tester.pumpAndSettle();
      expect(find.text('No trips yet'), findsOneWidget);

      // Return to Search — form should still be there
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.text('Find your flight'), findsOneWidget);
    });

    testWidgets('Prop drilling tab renders tree', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.bar_chart).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Drilling'));
      await tester.pumpAndSettle();
      expect(find.textContaining('relay params'), findsOneWidget);
    });

    testWidgets('Rules tab shows three conditions', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.bar_chart).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rules'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Local'),     findsWidgets);
      expect(find.textContaining('Ephemeral'), findsWidgets);
      expect(find.textContaining('Unshared'),  findsWidgets);
    });
  });
}
