import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_lesson_08/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Lesson 08 — Inclusive Audit Integration', () {
    testWidgets('App opens with three tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Inclusive Design Audit'), findsOneWidget);
      expect(find.text('Components'), findsOneWidget);
      expect(find.text('Audit'),      findsOneWidget);
      expect(find.text('Gestures'),   findsOneWidget);
    });

    testWidgets('Components tab shows semantic overlay by default', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      // Semantic overlay toggle is visible
      expect(find.text('Semantic Overlay'), findsOneWidget);
      // Green badge visible
      expect(find.textContaining('✓ 48dp'), findsWidgets);
    });

    testWidgets('Audit tab Run Audit produces results', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('Audit'));
      await tester.pumpAndSettle();
      expect(find.text('Tap "Run Audit" to check all components'), findsOneWidget);

      await tester.tap(find.text('Run Audit'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Results should replace initial zero-state placeholder.
      expect(find.text('Tap "Run Audit" to check all components'), findsNothing);
      expect(find.textContaining('Touch Target'), findsWidgets);
    });

    testWidgets('Gestures tab shows five gesture buttons', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('Gestures'));
      await tester.pumpAndSettle();
      expect(find.text('← Prev'),    findsOneWidget);
      expect(find.text('→ Next'),    findsOneWidget);
      expect(find.text('· Read'),    findsOneWidget);
      expect(find.text('↩ Activate'),findsOneWidget);
      expect(find.text('⟰ Scroll'),  findsOneWidget);
    });

    testWidgets('Gestures swipe right navigates focus', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('Gestures'));
      await tester.pumpAndSettle();

      // Initial: first element focused
      expect(find.text('Book Flight (button)'), findsOneWidget);

      // Swipe right → focus moves
      await tester.tap(find.text('→ Next'));
      await tester.pumpAndSettle();
      expect(find.text('Save Trip (button)'), findsOneWidget);
    });

    testWidgets('Bottom navigation buttons are actionable', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Components Overview'), findsOneWidget);

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.text('Run Audit'), findsOneWidget);

      await tester.tap(find.text('Discovery'));
      await tester.pumpAndSettle();
      expect(find.text('TALKBACK GESTURES'), findsOneWidget);

      await tester.tap(find.text('Bookings'));
      await tester.pumpAndSettle();
      expect(find.textContaining('not part of Lesson 08 demo yet.'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.textContaining('not part of Lesson 08 demo yet.'), findsOneWidget);
    });

    testWidgets('Focused element button in Gestures triggers activation log', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('Gestures'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Book Flight (button)'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Double-tap: activated'), findsOneWidget);
    });
  });
}
