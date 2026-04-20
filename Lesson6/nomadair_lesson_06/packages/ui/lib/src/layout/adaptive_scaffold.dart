import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

final class AdaptiveDestination {
  const AdaptiveDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.builder,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final WidgetBuilder builder;
}

final class AdaptiveScaffold extends StatefulWidget {
  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    this.title,
    this.forceStyle,
  }) : assert(destinations.length >= 2, 'At least 2 destinations required');

  final List<AdaptiveDestination> destinations;
  final String? title;
  final NavigationStyle? forceStyle;

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

final class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final style = widget.forceStyle ?? Breakpoints.styleFor(constraints.maxWidth);
        final body = widget.destinations[_selected].builder(context);
        return switch (style) {
          CompactNav() => Scaffold(
              appBar: AppBar(title: Text(widget.title ?? 'NomadAir')),
              body: body,
              bottomNavigationBar: NavigationBar(
                selectedIndex: _selected,
                onDestinationSelected: (i) => setState(() => _selected = i),
                destinations: widget.destinations
                    .map(
                      (d) => NavigationDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: d.label,
                      ),
                    )
                    .toList(),
              ),
            ),
          MediumNav() || ExpandedNav() => Scaffold(
              appBar: AppBar(title: Text(widget.title ?? 'NomadAir')),
              body: Row(
                children: [
                  NavigationRail(
                    extended: style is ExpandedNav,
                    selectedIndex: _selected,
                    onDestinationSelected: (i) => setState(() => _selected = i),
                    destinations: widget.destinations
                        .map(
                          (d) => NavigationRailDestination(
                            icon: Icon(d.icon),
                            selectedIcon: Icon(d.selectedIcon),
                            label: Text(d.label),
                          ),
                        )
                        .toList(),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: body),
                ],
              ),
            ),
        };
      },
    );
  }
}
