import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_lesson_15/features/state_explorer/widgets/rebuild_tracker_widget.dart';
import 'package:nomadair_lesson_15/features/search/screens/search_screen.dart';

Widget _wrap(Widget child) {
  final router = GoRouter(
    initialLocation: '/test',
    routes: [GoRoute(path:'/test', builder: (_, __) => Scaffold(body: child))],
  );
  return MaterialApp.router(
    theme: NomadAirTheme.light(), routerConfig: router);
}

Widget _wrapPlain(Widget child) => MaterialApp(
  theme: NomadAirTheme.light(),
  home: Scaffold(body: SingleChildScrollView(child: child)));

void main() {
  group('RebuildTrackerWidget', () {
    testWidgets('renders in correct mode by default', (tester) async {
      await tester.pumpWidget(
        _wrapPlain(const RebuildTrackerWidget()));
      expect(find.text('Isolated Counter'), findsOneWidget);
      expect(find.textContaining('never rebuilds'), findsWidgets);
    });

    testWidgets('toggle switches to anti-pattern mode', (tester) async {
      await tester.pumpWidget(
        _wrapPlain(const RebuildTrackerWidget()));
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(find.textContaining('Anti-pattern'), findsWidgets);
    });

    testWidgets('isolated counter increments on tap', (tester) async {
      await tester.pumpWidget(
        _wrapPlain(const RebuildTrackerWidget()));
      expect(find.text('0'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add_circle));
      await tester.pumpAndSettle(const Duration(milliseconds: 400));
      expect(find.text('1'), findsOneWidget);
    });
  });

  group('SearchScreen with AutomaticKeepAliveClientMixin', () {
    testWidgets('renders search form', (tester) async {
      await tester.pumpWidget(_wrap(const SearchScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Find your flight'), findsOneWidget);
      expect(find.text('Departure City'),   findsOneWidget);
    });

    testWidgets('lesson annotation visible', (tester) async {
      await tester.pumpWidget(_wrap(const SearchScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('AutomaticKeepAliveClientMixin'),
        findsOneWidget);
    });

    testWidgets('empty submit shows field error', (tester) async {
      await tester.pumpWidget(_wrap(const SearchScreen()));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Search Flights'));
      await tester.tap(find.text('Search Flights'));
      await tester.pumpAndSettle();
      expect(find.textContaining('departure city'), findsOneWidget);
    });

    testWidgets('one-way hides return date', (tester) async {
      await tester.pumpWidget(_wrap(const SearchScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Return Date'), findsOneWidget);
      await tester.tap(find.text('One Way'));
      await tester.pumpAndSettle();
      expect(find.text('Return Date'), findsNothing);
    });
  });
}
