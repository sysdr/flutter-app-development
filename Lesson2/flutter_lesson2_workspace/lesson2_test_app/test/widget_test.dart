import 'package:flutter_test/flutter_test.dart';
import 'package:lesson2_test_app/main.dart';

void main() {
  testWidgets('Lesson2 app builds and shows verification label', (WidgetTester tester) async {
    await tester.pumpWidget(const Lesson2VerificationApp());
    expect(find.text('HOT RELOAD READY'), findsOneWidget);
  });
}
