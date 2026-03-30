import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/main.dart';

String _metric(WidgetTester tester, Key key) {
  return tester.widget<Text>(find.byKey(key)).data!;
}

void main() {
  testWidgets('Dashboard metrics update after demo and interactions', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    const kPrimary = Key('metric_primary');
    const kAccent = Key('metric_accent');
    const kField = Key('metric_field');
    const kDemo = Key('metric_demo');

    expect(_metric(tester, kPrimary), '0');
    expect(_metric(tester, kAccent), '0');
    expect(_metric(tester, kField), '0');
    expect(_metric(tester, kDemo), '0');

    await tester.tap(find.text('Run demo (updates all metrics)'));
    await tester.pumpAndSettle();

    expect(_metric(tester, kPrimary), '1');
    expect(_metric(tester, kAccent), '1');
    expect(_metric(tester, kField), '1');
    expect(_metric(tester, kDemo), '1');

    final bookFinder = find.text('Book a Flight (Primary)');
    await tester.scrollUntilVisible(bookFinder, 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(bookFinder);
    await tester.pumpAndSettle();
    expect(_metric(tester, kPrimary), '2');

    final ScaffoldMessengerState messenger =
        tester.state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger));
    messenger.clearSnackBars();
    await tester.pumpAndSettle();

    final exploreFinder = find.text('Explore More (Accent)');
    await tester.scrollUntilVisible(exploreFinder, 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(exploreFinder);
    await tester.pumpAndSettle();
    expect(_metric(tester, kAccent), '2');

    final fieldFinder = find.byType(TextField);
    await tester.scrollUntilVisible(fieldFinder, 200, scrollable: find.byType(Scrollable).first);
    await tester.enterText(fieldFinder, 'Y');
    await tester.pump();
    expect(int.parse(_metric(tester, kField)), greaterThan(1));
  });
}
