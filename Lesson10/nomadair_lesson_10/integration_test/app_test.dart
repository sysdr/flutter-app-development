import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_lesson_10/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Lesson 10 — Feature Route Explorer', () {
    testWidgets('App launches with bottom navigation labels', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Feature Explorer'), findsOneWidget);
      expect(find.text('Screen vs Widget vs Page'), findsOneWidget);
    });

    testWidgets('Features tab shows four feature cards', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Discovery'), findsOneWidget);
      expect(find.text('Search'),    findsOneWidget);
      expect(find.text('Booking'),   findsOneWidget);
      await tester.fling(find.byType(ListView).first, const Offset(0, -700), 1200);
      await tester.pumpAndSettle();
      expect(find.text('Profile'),   findsOneWidget);
    });

    testWidgets('Opening Discovery navigates to DiscoveryScreen',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Navigate').first);
      await tester.pumpAndSettle();

      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('Opening Search navigates to SearchScreen',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Navigate').at(1));
      await tester.pumpAndSettle();

      expect(find.text('Search Flights'), findsWidgets);
      expect(find.text('Departure City'), findsOneWidget);
      expect(find.text('Destination'), findsOneWidget);
    });

    testWidgets('Concepts tab shows Page/Screen/Widget explanations',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Screen vs Widget vs Page').last);
      await tester.pumpAndSettle();

      expect(find.text('Page'),   findsOneWidget);
      expect(find.text('Screen'), findsOneWidget);
      expect(find.text('Widget'), findsOneWidget);
    });

    testWidgets('Concepts tab shows inspector sections', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Screen vs Widget vs Page').last);
      await tester.pumpAndSettle();

      expect(find.text('EXPLANATION'), findsOneWidget);
      expect(find.text('WIDGET TREE INSPECTOR'), findsOneWidget);
      expect(find.text('EXAMPLES'), findsOneWidget);
    });
  });
}
