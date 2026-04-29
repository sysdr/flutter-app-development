import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_lesson_12/features/search/screens/search_screen.dart';

Widget _wrapRouter(Widget child) {
  final router = GoRouter(
    initialLocation: '/test',
    routes: [
      GoRoute(
        path: '/test',
        builder: (_, __) => Scaffold(body: child),
      ),
    ],
  );
  return MaterialApp.router(
    theme: NomadAirTheme.light(),
    routerConfig: router,
  );
}

void main() {
  group('SearchScreen — deep link pre-fill', () {
    testWidgets('renders empty when no params', (tester) async {
      await tester.pumpWidget(
        _wrapRouter(const SearchScreen()));
      await tester.pumpAndSettle();
      final origin = find.bySemanticsLabel(RegExp('Departure City|Departure'));
      expect(origin, findsWidgets);
    });

    testWidgets('pre-fills origin from initialOrigin param', (tester) async {
      await tester.pumpWidget(
        _wrapRouter(const SearchScreen(
          initialOrigin: 'BOM', initialDestination: 'DXB')));
      await tester.pumpAndSettle();
      // Controller should have pre-filled text
      final fields = tester.widgetList<TextField>(
          find.byType(TextField)).toList();
      final origins = fields.where(
          (f) => f.controller?.text == 'BOM').toList();
      expect(origins, isNotEmpty,
          reason: 'Origin field should be pre-filled with BOM');
    });

    testWidgets('shows deep link badge when pre-filled', (tester) async {
      await tester.pumpWidget(
        _wrapRouter(const SearchScreen(
          initialOrigin: 'BOM', initialDestination: 'DXB')));
      await tester.pumpAndSettle();
      expect(find.text('Pre-filled from deep link'), findsOneWidget);
    });

    testWidgets('no badge when not pre-filled', (tester) async {
      await tester.pumpWidget(
        _wrapRouter(const SearchScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Pre-filled from deep link'), findsNothing);
    });
  });
}
