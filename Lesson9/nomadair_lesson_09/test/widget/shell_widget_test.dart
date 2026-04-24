import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

Widget _wrap(Widget child, {ThemeMode mode = ThemeMode.light}) =>
    MaterialApp(
      theme: NomadAirTheme.light(),
      darkTheme: NomadAirTheme.dark(),
      themeMode: mode,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child)),
    );

const _dest = DestinationModel(
  id:'dxb', city:'Dubai', country:'UAE', iataCode:'DXB',
  tagline:'City of gold', priceFromInr:18500, category:'flights',
  skyColorTop:0xFF1A237E, skyColorBottom:0xFFE65100,
);

void main() {
  group('DestinationCard — accessibility', () {
    testWidgets('MergeSemantics label contains city', (tester) async {
      await tester.pumpWidget(
        _wrap(DestinationCard(destination: _dest, onTap: () {})));
      final sem = tester.getSemantics(find.byType(DestinationCard));
      expect(sem.label, contains('Dubai'));
    });

    testWidgets('is a button when onTap provided', (tester) async {
      await tester.pumpWidget(
        _wrap(DestinationCard(destination: _dest, onTap: () {})));
      final sem = tester.getSemantics(find.byType(DestinationCard));
      expect(sem.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('not a button when onTap is null', (tester) async {
      await tester.pumpWidget(
        _wrap(const DestinationCard(destination: _dest)));
      final sem = tester.getSemantics(find.byType(DestinationCard));
      expect(sem.hasFlag(SemanticsFlag.isButton), isFalse);
    });

    testWidgets('renders city name', (tester) async {
      await tester.pumpWidget(
        _wrap(const DestinationCard(destination: _dest)));
      expect(find.text('Dubai'), findsOneWidget);
      expect(find.text('DXB'),   findsOneWidget);
    });

    testWidgets('renders in dark theme without error', (tester) async {
      await tester.pumpWidget(
        _wrap(const DestinationCard(destination: _dest),
          mode: ThemeMode.dark));
      expect(find.text('Dubai'), findsOneWidget);
    });
  });

  group('NomadButton rubric checks', () {
    testWidgets('zero raw ElevatedButton — uses FilledButton', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadButton(label: 'Book', onPressed: () {})));
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(FilledButton),   findsOneWidget);
    });

    testWidgets('has semantic label', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadButton(label: 'Search Flights', onPressed: () {})));
      final sem = tester.getSemantics(find.byType(NomadButton));
      expect(sem.label, contains('Search Flights'));
    });
  });

  group('NomadTextField rubric checks', () {
    testWidgets('error renders as text not color alone', (tester) async {
      await tester.pumpWidget(
        _wrap(const NomadTextField(
          label: 'Departure', error: 'Enter a departure city')));
      expect(find.text('Enter a departure city'), findsOneWidget);
    });

    testWidgets('is a textField in semantic tree', (tester) async {
      await tester.pumpWidget(
        _wrap(const NomadTextField(label: 'Departure City')));
      final sem = tester.getSemantics(find.byType(NomadTextField));
      expect(sem.hasFlag(SemanticsFlag.isTextField), isTrue);
    });
  });

  group('NomadChip — FilterChip selected state', () {
    testWidgets('selected:true is reflected in semantics', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadChip(
          label: 'Flights',
          variant: const FilterChipVariant(),
          selected: true,
          onTap: () {})));
      final sem = tester.getSemantics(find.byType(NomadChip));
      expect(sem.hasFlag(SemanticsFlag.isSelected), isTrue);
    });
  });
}
