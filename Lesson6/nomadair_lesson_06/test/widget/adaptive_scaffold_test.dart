import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

Widget _wrap(Widget child) => MaterialApp(theme: NomadAirTheme.light(), home: child);

const _destinations = <AdaptiveDestination>[
  AdaptiveDestination(
    icon: Icons.home,
    selectedIcon: Icons.home_filled,
    label: 'Home',
    builder: _home,
  ),
  AdaptiveDestination(
    icon: Icons.search,
    selectedIcon: Icons.search,
    label: 'Search',
    builder: _search,
  ),
];

Widget _home(BuildContext _) => const Text('Home Content');
Widget _search(BuildContext _) => const Text('Search Content');

void main() {
  testWidgets('Compact style uses NavigationBar', (tester) async {
    await tester.pumpWidget(
      _wrap(AdaptiveScaffold(destinations: _destinations, forceStyle: const CompactNav())),
    );
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });
}
