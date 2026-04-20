import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_04/main.dart';

void main() {
  testWidgets('Metrics are non-zero and update on demo run', (tester) async {
    await tester.pumpWidget(const NomadAirApp());
    await tester.pump();
    expect(find.text('0'), findsNothing);
    await tester.tap(find.text('Run Demo'));
    await tester.pump();
    expect(find.text('14'), findsOneWidget);
  });
}
