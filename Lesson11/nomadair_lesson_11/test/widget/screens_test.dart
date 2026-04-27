import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_lesson_11/features/not_found/screens/not_found_screen.dart';
import 'package:nomadair_lesson_11/features/trips/screens/trips_screen.dart';

Widget _wrapWithRouter(String location, Widget child) {
  final router = GoRouter(
    initialLocation: location,
    errorBuilder: (ctx, state) => NotFoundScreen(
        location: state.uri.toString()),
    routes: [
      GoRoute(path: location, builder: (_, __) => child),
    ],
  );
  return MaterialApp.router(
    theme: NomadAirTheme.light(),
    routerConfig: router,
  );
}

void main() {
  group('NotFoundScreen', () {
    testWidgets('renders 404 message', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: const NotFoundScreen(location: '/bad/route'),
      ));
      expect(find.text('404 — Not Found'), findsOneWidget);
      expect(find.text('/bad/route'),      findsOneWidget);
    });

    testWidgets('Go to Discovery button visible', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: const NotFoundScreen(location: '/unknown'),
      ));
      expect(find.text('Go to Discovery'), findsOneWidget);
    });
  });

  group('TripsScreen', () {
    testWidgets('renders empty state', (tester) async {
      await tester.pumpWidget(
        _wrapWithRouter('/trips',
          TripsScreen(onSearchTap: () {})));
      await tester.pumpAndSettle();
      expect(find.text('No trips yet'), findsOneWidget);
    });

    testWidgets('Start Searching calls onSearchTap', (tester) async {
      var called = false;
      await tester.pumpWidget(
        _wrapWithRouter('/trips',
          TripsScreen(onSearchTap: () => called = true)));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start Searching'));
      expect(called, isTrue);
    });
  });
}
