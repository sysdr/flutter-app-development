import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:provider/provider.dart';
import 'package:nomadair_lesson_16/features/search/models/selected_city.dart';
import 'package:nomadair_lesson_16/features/search/providers/search_criteria_notifier.dart';
import 'package:nomadair_lesson_16/features/search/screens/search_screen.dart';
import 'package:nomadair_lesson_16/features/search/screens/search_results_screen.dart';
import 'package:nomadair_lesson_16/features/state_explorer/screens/state_explorer_screen.dart';

Widget _wrapWithProvider(Widget child,
    {SearchCriteriaNotifier? notifier}) {
  final n = notifier ?? SearchCriteriaNotifier();
  final router = GoRouter(
    initialLocation: '/test',
    routes: [GoRoute(path: '/test', builder: (_, __) => child)],
  );
  return ChangeNotifierProvider.value(
    value: n,
    child: MaterialApp.router(
      theme: NomadAirTheme.light(), routerConfig: router));
}

void main() {
  group('SearchScreen with Provider', () {
    testWidgets('renders form', (tester) async {
      await tester.pumpWidget(_wrapWithProvider(const SearchScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Find your flight'), findsOneWidget);
      expect(find.text('Departure City'),   findsOneWidget);
    });

    testWidgets('shows pre-existing criteria from Provider', (tester)
        async {
      const bom = SelectedCity(
        name: 'Mumbai', iata: 'BOM', cityId: 6291);
      final notifier = SearchCriteriaNotifier()..setOrigin(bom);
      await tester.pumpWidget(
        _wrapWithProvider(const SearchScreen(), notifier: notifier));
      await tester.pumpAndSettle();
      expect(find.text('Mumbai (BOM)'), findsOneWidget);
    });

    testWidgets('lesson annotation shows Provider', (tester) async {
      await tester.pumpWidget(_wrapWithProvider(const SearchScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('Provider'), findsWidgets);
    });

    testWidgets('empty submit shows field error', (tester) async {
      await tester.pumpWidget(_wrapWithProvider(const SearchScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Search Flights'));
      await tester.pumpAndSettle();
      expect(find.textContaining('departure city'), findsOneWidget);
    });

    testWidgets('one-way hides return date', (tester) async {
      await tester.pumpWidget(_wrapWithProvider(const SearchScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Return Date'), findsOneWidget);
      await tester.tap(find.text('One Way'));
      await tester.pumpAndSettle();
      expect(find.text('Return Date'), findsNothing);
    });
  });

  group('SearchResultsScreen with Provider', () {
    testWidgets('renders without GoRouter extra', (tester) async {
      final notifier = SearchCriteriaNotifier();
      final router = GoRouter(
        initialLocation: '/results',
        routes: [GoRoute(
          path: '/results',
          builder: (_, __) => const SearchResultsScreen())],
      );
      await tester.pumpWidget(ChangeNotifierProvider.value(
        value: notifier,
        child: MaterialApp.router(
          theme: NomadAirTheme.light(), routerConfig: router)));
      await tester.pumpAndSettle();
      expect(find.text('Search Results'), findsOneWidget);
    });

    testWidgets('shows criteria from Provider in AppBar', (tester)
        async {
      const bom = SelectedCity(
        name: 'Mumbai', iata: 'BOM', cityId: 6291);
      const dxb = SelectedCity(
        name: 'Dubai', iata: 'DXB', cityId: 5001);
      final notifier = SearchCriteriaNotifier()
        ..setOrigin(bom)
        ..setDestination(dxb);
      final router = GoRouter(
        initialLocation: '/results',
        routes: [GoRoute(
          path: '/results',
          builder: (_, __) => const SearchResultsScreen())],
      );
      await tester.pumpWidget(ChangeNotifierProvider.value(
        value: notifier,
        child: MaterialApp.router(
          theme: NomadAirTheme.light(), routerConfig: router)));
      await tester.pumpAndSettle();
      expect(find.text('BOM → DXB'), findsOneWidget);
    });

    testWidgets('New Search button is present', (tester) async {
      final notifier = SearchCriteriaNotifier();
      final router = GoRouter(
        initialLocation: '/results',
        routes: [GoRoute(
          path: '/results',
          builder: (_, __) => const SearchResultsScreen())],
      );
      await tester.pumpWidget(ChangeNotifierProvider.value(
        value: notifier,
        child: MaterialApp.router(
          theme: NomadAirTheme.light(), routerConfig: router)));
      await tester.pumpAndSettle();
      expect(find.text('New Search'), findsOneWidget);
    });
  });

  group('StateExplorer', () {
    testWidgets('has 4 tabs in L16', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: const StateExplorerScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Rebuild'),  findsOneWidget);
      expect(find.text('Drilling'), findsOneWidget);
      expect(find.text('Rules'),    findsOneWidget);
      expect(find.text('Provider'), findsOneWidget);
    });

    testWidgets('Provider tab shows comparison table', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: const StateExplorerScreen()));
      await tester.pumpAndSettle();
      // Navigate to Provider tab
      await tester.tap(find.text('Provider'));
      await tester.pumpAndSettle();
      expect(find.textContaining('ChangeNotifier'), findsWidgets);
    });
  });
}
