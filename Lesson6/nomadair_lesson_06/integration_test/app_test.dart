import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomadair_lesson_06/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('App boots', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Adaptive'), findsOneWidget);
  });
}
