import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomadair_lesson_05/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Lesson 05 — Component Showcase Integration', () {
    testWidgets('App opens with four tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.text('Buttons'),    findsOneWidget);
      expect(find.text('Cards'),      findsOneWidget);
      expect(find.text('TextFields'), findsOneWidget);
      expect(find.text('Chips'),      findsOneWidget);
    });

    testWidgets('Metrics strip: non-zero values and demo run', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey<String>('metric_flights_value')), findsOneWidget);
      expect(find.text('0'), findsNothing);
      await tester.tap(find.text('Run metrics demo'));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsNothing);
    });

    testWidgets('Buttons tab: tap Book Flight triggers loading', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // NomadButton with 'Book Flight' label
      await tester.tap(find.text('Book Flight').first);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Cards tab renders three card variants', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cards'));
      await tester.pumpAndSettle();

      expect(find.textContaining('IndiGo'),    findsOneWidget);
      expect(find.textContaining('Air India'),  findsOneWidget);
      expect(find.textContaining('Emirates'),   findsOneWidget);
    });

    testWidgets('TextFields tab: suffix icon tap toggles password', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('TextFields'));
      await tester.pumpAndSettle();

      // Tap visibility icon
      final vis = find.byIcon(Icons.visibility_outlined);
      expect(vis, findsOneWidget);
      await tester.tap(vis);
      await tester.pumpAndSettle();
      // After tap: icon switches to visibility_off
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('Chips tab: FilterChip toggles selected state', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chips'));
      await tester.pumpAndSettle();

      // Tap Economy chip — should toggle to selected
      await tester.tap(find.text('Economy'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Active: Economy'), findsOneWidget);
    });
  });
}
