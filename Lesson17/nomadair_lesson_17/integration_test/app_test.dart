import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_lesson_17/core/services/theme_preference_service.dart';
import 'package:nomadair_lesson_17/router/app_router.dart';
import 'package:nomadair_lesson_17/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SharedPrefsThemeService.resetForTesting();
    AppRouter.isLoggedIn.value = false;
  });
  group('L17 Integration', () {
    /// Discovery runs a repeating shimmer; avoid pumpAndSettle on that screen.
    Future<void> pumpPastDiscoveryLoad(WidgetTester tester) async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1400));
    }

    testWidgets('app launches on Discover', (tester) async {
      app.main();
      await pumpPastDiscoveryLoad(tester);
      expect(find.text('Discover'), findsAtLeastNWidgets(1));
    });
    testWidgets('Search tab opens form', (tester) async {
      app.main();
      await pumpPastDiscoveryLoad(tester);
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.text('Find your flight'), findsOneWidget);
    });
    testWidgets('dark mode toggle swaps toolbar icon', (tester) async {
      app.main();
      await pumpPastDiscoveryLoad(tester);
      expect(find.byIcon(Icons.dark_mode), findsWidgets);
      await tester.tap(find.byIcon(Icons.dark_mode).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byIcon(Icons.light_mode), findsWidgets);
    });
  });
}
