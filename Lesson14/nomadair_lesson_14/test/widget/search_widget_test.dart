import 'dart:ui' show SemanticsFlag;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_lesson_14/features/search/screens/search_screen.dart';
import 'package:nomadair_lesson_14/features/search/widgets/cabin_class_selector.dart';
import 'package:nomadair_lesson_14/features/search/models/search_criteria.dart';

Widget _wrapWithRouter(Widget child) {
  final router = GoRouter(
    initialLocation: '/test',
    routes: [GoRoute(path: '/test', builder: (_, __) => Scaffold(body: child))],
  );
  return MaterialApp.router(
    theme: NomadAirTheme.light(),
    routerConfig: router,
  );
}

void main() {
  group('SearchScreen', () {
    testWidgets('renders all form sections', (tester) async {
      await tester.pumpWidget(
        _wrapWithRouter(const SearchScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Find your flight'), findsOneWidget);
      expect(find.text('Departure City'),   findsOneWidget);
      expect(find.text('Destination'),      findsOneWidget);
      expect(find.text('Departure Date'),   findsOneWidget);
      expect(find.text('Passengers'),        findsOneWidget);
      expect(find.text('Cabin Class'),       findsOneWidget);
      expect(find.text('Search Flights'),    findsOneWidget);
    });

    testWidgets('trip type toggle visible', (tester) async {
      await tester.pumpWidget(
        _wrapWithRouter(const SearchScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Round Trip'), findsOneWidget);
      expect(find.text('One Way'),    findsOneWidget);
    });

    testWidgets('switching to One Way hides return date', (tester) async {
      await tester.pumpWidget(
        _wrapWithRouter(const SearchScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Return Date'), findsOneWidget);
      await tester.tap(find.text('One Way'));
      await tester.pumpAndSettle();
      expect(find.text('Return Date'), findsNothing);
    });

    testWidgets('submit with empty fields shows error', (tester) async {
      await tester.pumpWidget(
        _wrapWithRouter(const SearchScreen()));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Search Flights'));
      await tester.tap(find.text('Search Flights'));
      await tester.pumpAndSettle();

      expect(find.text('Please select a valid departure city'),
        findsOneWidget);
    });

    testWidgets('deep link badge shows when initialOrigin set',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithRouter(const SearchScreen(
          initialOrigin: 'BOM', initialDestination: 'DXB')));
      await tester.pumpAndSettle();
      expect(find.text('Pre-filled from deep link'), findsOneWidget);
    });
  });

  group('CabinClassSelector', () {
    testWidgets('shows all four cabin classes', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: Scaffold(
          body: CabinClassSelector(
            value:     CabinClass.economy,
            onChanged: (_) {},
          ),
        ),
      ));
      expect(find.text('Economy'),         findsOneWidget);
      expect(find.text('Premium Economy'), findsOneWidget);
      expect(find.text('Business'),        findsOneWidget);
      expect(find.text('First Class'),     findsOneWidget);
    });

    testWidgets('selected cabin is highlighted', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: Scaffold(
          body: CabinClassSelector(
            value:     CabinClass.business,
            onChanged: (_) {},
          ),
        ),
      ));
      final sem = tester.getSemantics(
        find.bySemanticsLabel(RegExp('Business cabin.*selected')));
      expect(sem.hasFlag(SemanticsFlag.isSelected), isTrue);
    });

    testWidgets('tapping chip calls onChanged', (tester) async {
      CabinClass? changed;
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: Scaffold(
          body: CabinClassSelector(
            value:     CabinClass.economy,
            onChanged: (c) => changed = c,
          ),
        ),
      ));
      await tester.tap(find.text('Business'));
      expect(changed, equals(CabinClass.business));
    });
  });
}
