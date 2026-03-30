import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app_day3/main.dart';

String _metric(WidgetTester tester, Key key) {
  return tester.widget<Text>(find.byKey(key, skipOffstage: false)).data!;
}

void main() {
  testWidgets('Dashboard metrics update after demo and interactions', (WidgetTester tester) async {
    await tester.pumpWidget(const TravelApp());
    await tester.pumpAndSettle();

    const Key kPrimary = Key('metric_primary');
    const Key kAccent = Key('metric_accent');
    const Key kField = Key('metric_field');
    const Key kDemo = Key('metric_demo');

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

    final Finder searchFinder = find.text('Find Flights');
    await tester.scrollUntilVisible(searchFinder, 200.0, scrollable: find.byType(Scrollable).first);
    await tester.tap(searchFinder);
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(_metric(tester, kPrimary), '2');

    final ScaffoldMessengerState messenger =
        tester.state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger));
    messenger.clearSnackBars();
    await tester.pumpAndSettle();

    final Finder detailsFinder = find.text('View Flight Details (Assignment)');
    await tester.scrollUntilVisible(detailsFinder, 200.0, scrollable: find.byType(Scrollable).first);
    await tester.tap(detailsFinder);
    await tester.pumpAndSettle();
    expect(_metric(tester, kAccent), '2');

    await tester.pageBack();
    await tester.pumpAndSettle();

    final Finder expandIcon = find.byIcon(Icons.keyboard_arrow_down);
    await tester.scrollUntilVisible(expandIcon, 200.0, scrollable: find.byType(Scrollable).first);
    await tester.tap(expandIcon);
    await tester.pumpAndSettle();
    expect(_metric(tester, kField), '2');
  });
}
