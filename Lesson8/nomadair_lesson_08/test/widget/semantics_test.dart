import 'dart:ui' show SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

Widget _wrap(Widget child, {ThemeMode mode = ThemeMode.light}) =>
    MaterialApp(
      theme: NomadAirTheme.light(),
      darkTheme: NomadAirTheme.dark(),
      themeMode: mode,
      home: Scaffold(body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(16),
        child: child))),
    );

void main() {
  group('NomadButton — semantics', () {
    testWidgets('has button flag in SemanticsNode', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadButton(label: 'Book', onPressed: () {})));
      final sem = tester.getSemantics(find.byType(NomadButton));
      expect(sem.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('label is announced', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadButton(label: 'Book Flight', onPressed: () {})));
      final sem = tester.getSemantics(find.byType(NomadButton));
      expect(sem.label, contains('Book Flight'));
    });

    testWidgets('disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        _wrap(const NomadButton(label: 'Disabled', onPressed: null)));
      final sem = tester.getSemantics(find.byType(NomadButton));
      expect(sem.hasFlag(SemanticsFlag.isEnabled), isFalse);
    });

    testWidgets('custom semanticLabel overrides label', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadButton(
          label: 'OK', semanticLabel: 'Confirm booking', onPressed: () {})));
      final sem = tester.getSemantics(find.byType(NomadButton));
      expect(sem.label, contains('Confirm booking'));
    });
  });

  group('NomadFlightCard — MergeSemantics', () {
    const flight = FlightModel(
      id: 'AI-101', airline: 'Air India',
      origin: 'BOM', destination: 'DEL',
      durationMinutes: 125, priceInr: 4200, stops: 0,
    );

    testWidgets('merged label contains airline', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadFlightCard(flight: flight, onTap: () {})));
      final sem = tester.getSemantics(find.byType(NomadFlightCard));
      expect(sem.label, contains('Air India'));
    });

    testWidgets('merged label contains price', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadFlightCard(flight: flight, onTap: () {})));
      final sem = tester.getSemantics(find.byType(NomadFlightCard));
      expect(sem.label, contains('4200'));
    });

    testWidgets('is a button when onTap provided', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadFlightCard(flight: flight, onTap: () {})));
      final sem = tester.getSemantics(find.byType(NomadFlightCard));
      expect(sem.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('not a button when onTap is null', (tester) async {
      await tester.pumpWidget(
        _wrap(const NomadFlightCard(flight: flight)));
      final sem = tester.getSemantics(find.byType(NomadFlightCard));
      expect(sem.hasFlag(SemanticsFlag.isButton), isFalse);
    });
  });

  group('NomadTextField — semantics', () {
    testWidgets('is a text field', (tester) async {
      await tester.pumpWidget(
        _wrap(const NomadTextField(label: 'Departure City')));
      final sem = tester.getSemantics(find.byType(NomadTextField));
      expect(sem.hasFlag(SemanticsFlag.isTextField), isTrue);
    });

    testWidgets('label is announced', (tester) async {
      await tester.pumpWidget(
        _wrap(const NomadTextField(label: 'Departure City')));
      final sem = tester.getSemantics(find.byType(NomadTextField));
      expect(sem.label, contains('Departure City'));
    });

    testWidgets('disabled field is not enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(const NomadTextField(label: 'City', enabled: false)));
      final sem = tester.getSemantics(find.byType(NomadTextField));
      expect(sem.hasFlag(SemanticsFlag.isEnabled), isFalse);
    });
  });

  group('NomadChip — semantics', () {
    testWidgets('FilterChip reflects selected state true', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadChip(
          label: 'Non-stop',
          variant: const FilterChipVariant(),
          selected: true,
          onTap: () {})));
      final sem = tester.getSemantics(find.byType(NomadChip));
      expect(sem.hasFlag(SemanticsFlag.isSelected), isTrue);
    });

    testWidgets('FilterChip reflects selected state false', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadChip(
          label: 'Non-stop',
          variant: const FilterChipVariant(),
          selected: false,
          onTap: () {})));
      final sem = tester.getSemantics(find.byType(NomadChip));
      expect(sem.hasFlag(SemanticsFlag.isSelected), isFalse);
    });
  });
}
