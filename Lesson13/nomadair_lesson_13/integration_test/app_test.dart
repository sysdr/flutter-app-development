import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:nomadair_lesson_13/core/services/theme_preference_service.dart';
import 'package:nomadair_lesson_13/router/app_router.dart';
import 'package:nomadair_lesson_13/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AppRouter.isLoggedIn.value = false;
  });

  group('Lesson 13 — Discovery Feed Integration', () {
    testWidgets('App launches with Discover tab', (tester) async {
      app.main();
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('Shimmer skeleton visible during load', (tester) async {
      app.main();
      await tester.pump(); // first frame
      await tester.pump(const Duration(milliseconds: 100));
      // Shimmer should be visible before 1500ms delay completes
      expect(find.byType(DiscoveryCardShimmer), findsWidgets);
    });

    testWidgets('Real cards appear after load', (tester) async {
      app.main();
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Dubai'),     findsOneWidget);
      expect(find.text('Singapore'), findsOneWidget);
    });

    testWidgets('Filter chips visible after load', (tester) async {
      app.main();
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('All'),     findsOneWidget);
      expect(find.text('Flights'), findsOneWidget);
      expect(find.text('Hotels'),  findsOneWidget);
    });

    testWidgets('Mode toggle switches to PageView', (tester) async {
      app.main();
      await tester.pump(const Duration(seconds: 3));

      await tester.tap(find.byIcon(Icons.view_day_outlined).first);
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('Tap destination navigates to detail', (tester) async {
      app.main();
      await tester.pump(const Duration(seconds: 3));

      await tester.tap(find.text('Dubai').first);
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('City of gold'), findsOneWidget);
    });

    testWidgets('Theme toggle works', (tester) async {
      app.main();
      await tester.pump(const Duration(seconds: 3));

      final ctx = tester.element(find.byType(MaterialApp).first);
      expect(Theme.of(ctx).brightness, equals(Brightness.light));

      await tester.tap(find.byIcon(Icons.dark_mode).first);
      await tester.pump(const Duration(milliseconds: 500));
      expect(Theme.of(ctx).brightness, equals(Brightness.dark));
    });
  });
}
