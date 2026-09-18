import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomadair_lesson_01/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Lesson 01 — Environment Check Integration Tests', () {
    testWidgets(
      'All checks complete — no tiles remain in Waiting state',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Initial state: 7 pending tiles
        expect(find.text('Waiting...').evaluate().length, equals(7));

        // Tap Run Checks
        await tester.tap(find.text('Run Checks'));

        // Wait for all 7 checks (7 × 280ms delay + async overhead)
        await tester.pumpAndSettle(const Duration(seconds: 10));

        // No tile should remain in Waiting... state
        expect(find.text('Waiting...'), findsNothing);

        // Log panel should contain timestamped entries
        expect(find.textContaining('['), findsWidgets);
      },
    );

    testWidgets(
      'Inject Failure sets Screen Dimensions tile to failing state',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Inject Failure'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('below minimum (simulated)'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.cancel), findsWidgets);
      },
    );
  });
}
