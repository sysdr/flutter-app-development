import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_lesson_12/core/services/theme_preference_service.dart';
import 'package:nomadair_lesson_12/router/app_router.dart';
import 'package:nomadair_lesson_12/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SharedPrefsThemeService._instance = null;
    AppRouter.isLoggedIn.value = false;
  });

  group('Lesson 12 — Deep Link Integration', () {
    testWidgets('App launches on Discovery tab', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('Deep Link Explorer accessible from app', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      // Link icon in AppBar
      expect(find.byIcon(Icons.link), findsOneWidget);
      await tester.tap(find.byIcon(Icons.link).first);
      await tester.pumpAndSettle();
      expect(find.text('Deep Link Explorer'), findsOneWidget);
    });

    testWidgets('Simulate tab has 5 deep link entries', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.link).first);
      await tester.pumpAndSettle();
      expect(find.text('Simulate'), findsOneWidget);
      expect(find.text('Search (simple)'), findsOneWidget);
      expect(find.text('Discovery'),       findsOneWidget);
    });

    testWidgets('Simulate deep link navigates correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.link).first);
      await tester.pumpAndSettle();

      // Simulate "Discovery" deep link
      await tester.tap(
        find.text('Simulate Deep Link').at(2)); // Discovery entry
      await tester.pumpAndSettle();

      expect(find.text('Discover'), findsWidgets);
    });

    testWidgets('ADB Commands tab shows copy buttons', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.link).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('ADB Commands'));
      await tester.pumpAndSettle();

      expect(find.text('Copy'), findsWidgets);
      expect(find.textContaining('adb shell'), findsWidgets);
    });

    testWidgets('Manifest tab shows intent filter code', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.link).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Manifest'));
      await tester.pumpAndSettle();

      expect(find.textContaining('launchMode'),   findsWidgets);
      expect(find.textContaining('singleTop'),    findsWidgets);
      expect(find.textContaining('intent-filter'), findsWidgets);
    });
  });
}
