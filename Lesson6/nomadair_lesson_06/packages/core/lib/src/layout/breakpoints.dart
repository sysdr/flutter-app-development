import 'package:flutter/material.dart';

sealed class NavigationStyle {
  const NavigationStyle();
}

final class CompactNav extends NavigationStyle {
  const CompactNav();
}

final class MediumNav extends NavigationStyle {
  const MediumNav();
}

final class ExpandedNav extends NavigationStyle {
  const ExpandedNav();
}

abstract final class Breakpoints {
  static const double compact = 600.0;
  static const double medium = 840.0;

  static NavigationStyle styleFor(double width) {
    if (width >= medium) return const ExpandedNav();
    if (width >= compact) return const MediumNav();
    return const CompactNav();
  }

  static String zoneName(double width) => switch (styleFor(width)) {
        CompactNav() => 'compact',
        MediumNav() => 'medium',
        ExpandedNav() => 'expanded',
      };

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;
}
