import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomadair_lesson_03/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Lesson 03 — Package Scaffold Integration', () {
    testWidgets(
      'App opens Package Explorer with three tabs',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        expect(find.text('Architecture'), findsOneWidget);
        expect(find.text('Packages'),     findsOneWidget);
        expect(find.text('Verify'),       findsOneWidget);
      },
    );

    testWidgets(
      'Packages tab lists all three packages',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Packages'));
        await tester.pumpAndSettle();

        expect(find.textContaining('nomadair_core'), findsWidgets);
        expect(find.textContaining('nomadair_ui'),   findsWidgets);
        expect(find.textContaining('nomadair_data'), findsWidgets);
      },
    );

    testWidgets(
      'Verify tab: all five checks pass after Verify All Packages',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Verify'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Verify All Packages'));

        // Allow all async checks to complete (5 × 250ms + overhead)
        await tester.pumpAndSettle(const Duration(seconds: 8));

        // Log should mention actual flight data from MockFlightRepository
        expect(find.textContaining('BOM → DEL'), findsWidgets);

        // Passed count should be 5
        final passedText = find.text('5');
        expect(passedText, findsAtLeastNWidgets(1));
      },
    );

    testWidgets(
      'Inject Violation shows boundary violation in log',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Verify'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Inject Violation'));
        await tester.pumpAndSettle();

        expect(find.textContaining('boundary violation'), findsWidgets);
        expect(find.textContaining('BLOCKED'), findsWidgets);
      },
    );
  });
}
