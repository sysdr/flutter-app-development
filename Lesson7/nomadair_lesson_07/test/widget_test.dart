import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomadair_lesson_07/main.dart' as app;

void main() {
  testWidgets('DarkModeExplorer tabs render', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await app.main();
    await tester.pumpAndSettle();
    expect(find.text('DarkModeExplorer'), findsOneWidget);
    expect(find.text('TOKENS'), findsOneWidget);
    expect(find.text('TINTING'), findsOneWidget);
    expect(find.text('PERSIST'), findsOneWidget);
  });
}
