import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomadair_lesson_04/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('demo keeps metrics non-zero on emulator', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Flights Checked'), findsOneWidget);
    expect(find.text('Latency (ms)'), findsOneWidget);
    expect(find.text('Success Rate (%)'), findsOneWidget);
    expect(find.text('0'), findsNothing);
    await tester.tap(find.text('Run Demo'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsNothing);
  });
}
