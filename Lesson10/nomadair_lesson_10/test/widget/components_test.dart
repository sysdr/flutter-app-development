import 'dart:ui' show SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:nomadair_lesson_10/features/discovery/models/destination_model.dart';
import 'package:nomadair_lesson_10/features/discovery/widgets/destination_card_widget.dart';
import 'package:nomadair_lesson_10/features/discovery/widgets/filter_chip_bar_widget.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: NomadAirTheme.light(),
  darkTheme: NomadAirTheme.dark(),
  home: Scaffold(body: SingleChildScrollView(
    padding: const EdgeInsets.all(16), child: child)));

const _dest = DiscoveryDestination(
  id:'dxb',city:'Dubai',country:'UAE',iataCode:'DXB',
  tagline:'City of gold',priceFromInr:18500,category:'flights',
  skyColorTop:0xFF1A237E,skyColorBottom:0xFFE65100,trendingRank:1);

void main() {
  group('DestinationCardWidget', () {
    testWidgets('renders city name', (tester) async {
      await tester.pumpWidget(_wrap(
        const DestinationCardWidget(destination: _dest)));
      expect(find.text('Dubai'), findsOneWidget);
    });

    testWidgets('shows trending rank badge', (tester) async {
      await tester.pumpWidget(_wrap(
        const DestinationCardWidget(destination: _dest)));
      expect(find.text('#1'), findsOneWidget);
    });

    testWidgets('has merged semantics label with city', (tester) async {
      await tester.pumpWidget(_wrap(
        DestinationCardWidget(destination: _dest, onTap: () {})));
      final sem = tester.getSemantics(
          find.byType(DestinationCardWidget));
      expect(sem.label, contains('Dubai'));
    });

    testWidgets('is a button when onTap provided', (tester) async {
      await tester.pumpWidget(_wrap(
        DestinationCardWidget(destination: _dest, onTap: () {})));
      final sem = tester.getSemantics(
          find.byType(DestinationCardWidget));
      expect(sem.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('fires onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        DestinationCardWidget(
          destination: _dest, onTap: () => tapped = true)));
      await tester.tap(find.byType(DestinationCardWidget));
      expect(tapped, isTrue);
    });
  });

  group('FilterChipBarWidget', () {
    testWidgets('renders three filter chips', (tester) async {
      await tester.pumpWidget(_wrap(FilterChipBarWidget(
        active: DiscoveryFilter.all, onChanged: (_) {})));
      expect(find.text('All'),     findsOneWidget);
      expect(find.text('Flights'), findsOneWidget);
      expect(find.text('Hotels'),  findsOneWidget);
    });

    testWidgets('fires onChanged when chip tapped', (tester) async {
      DiscoveryFilter? changed;
      await tester.pumpWidget(_wrap(FilterChipBarWidget(
        active: DiscoveryFilter.all,
        onChanged: (f) => changed = f)));
      await tester.tap(find.text('Flights'));
      expect(changed, equals(DiscoveryFilter.flights));
    });

    testWidgets('active chip shows as selected', (tester) async {
      await tester.pumpWidget(_wrap(FilterChipBarWidget(
        active: DiscoveryFilter.hotels, onChanged: (_) {})));
      // Hotels chip selected, others not
      final chips = tester.widgetList<FilterChip>(
          find.byType(FilterChip)).toList();
      final hotelsChip = chips.firstWhere(
          (c) => (c.label as Text).data == 'Hotels');
      expect(hotelsChip.selected, isTrue);
    });
  });
}
