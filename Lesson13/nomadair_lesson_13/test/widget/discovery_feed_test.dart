import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:nomadair_lesson_13/features/discovery/models/destination_model.dart';
import 'package:nomadair_lesson_13/features/discovery/widgets/destination_card_widget.dart';

Widget _wrap(Widget child) {
  final router = GoRouter(
    initialLocation: '/test',
    routes: [GoRoute(path: '/test', builder: (_, __) => child)],
  );
  return MaterialApp.router(
    theme: NomadAirTheme.light(),
    routerConfig: router,
  );
}

const _dest = DiscoveryDestination(
  id:'dxb', city:'Dubai', country:'UAE', iataCode:'DXB',
  tagline:'City of gold', priceFromInr:18500, category:'flights',
  skyColorTop:0xFF1A237E, skyColorBottom:0xFFE65100, trendingRank:1,
);

void main() {
  group('DestinationCardWidget', () {
    testWidgets('renders city name', (tester) async {
      await tester.pumpWidget(_wrap(
        const DestinationCardWidget(destination: _dest)));
      expect(find.text('Dubai'), findsOneWidget);
    });

    testWidgets('shows trending badge #1', (tester) async {
      await tester.pumpWidget(_wrap(
        const DestinationCardWidget(destination: _dest)));
      expect(find.text('#1'), findsOneWidget);
    });

    testWidgets('has merged semantics label', (tester) async {
      await tester.pumpWidget(_wrap(
        DestinationCardWidget(
          destination: _dest, onTap: () {})));
      final sem = tester.getSemantics(
        find.byType(DestinationCardWidget));
      expect(sem.label, contains('Dubai'));
      expect(sem.label, contains('UAE'));
    });

    testWidgets('button flag when onTap provided', (tester) async {
      await tester.pumpWidget(_wrap(
        DestinationCardWidget(
          destination: _dest, onTap: () {})));
      final sem = tester.getSemantics(
        find.byType(DestinationCardWidget));
      expect(sem.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        DestinationCardWidget(
          destination: _dest,
          onTap: () => tapped = true)));
      await tester.tap(find.byType(DestinationCardWidget));
      expect(tapped, isTrue);
    });

    testWidgets('renders in dark theme without overflow', (tester) async {
      final router = GoRouter(
        initialLocation: '/t',
        routes: [GoRoute(path:'/t', builder:(_, __) =>
          const DestinationCardWidget(destination: _dest))],
      );
      await tester.pumpWidget(MaterialApp.router(
        darkTheme: NomadAirTheme.dark(),
        themeMode: ThemeMode.dark,
        routerConfig: router,
      ));
      expect(find.text('Dubai'), findsOneWidget);
    });
  });

  group('ShimmerBox', () {
    testWidgets('renders without error', (tester) async {
      final ctrl = AnimationController(
        vsync: tester,
        duration: const Duration(milliseconds: 1400),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: ShimmerBox(
          animation: ctrl,
          width: 200, height: 120)),
      ));
      expect(find.byType(ShimmerBox), findsOneWidget);
      ctrl.dispose();
    });
  });

  group('DiscoveryCardShimmer', () {
    testWidgets('renders without error', (tester) async {
      final ctrl = AnimationController(
        vsync: tester,
        duration: const Duration(milliseconds: 1400),
      );
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: Scaffold(body: DiscoveryCardShimmer(animation: ctrl)),
      ));
      expect(find.byType(DiscoveryCardShimmer), findsOneWidget);
      ctrl.dispose();
    });
  });
}
