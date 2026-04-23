import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomadair_lesson_07/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('persist tab buttons are available', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text('PERSIST'));
    await tester.pumpAndSettle();
    expect(find.text('Save Light'), findsOneWidget);
    expect(find.text('Save Dark'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
  });
}
