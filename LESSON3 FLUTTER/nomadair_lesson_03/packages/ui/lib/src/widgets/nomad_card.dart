import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

/// NomadAir's base card component.
///
/// Wraps [Card] with consistent padding and the NomadAir border radius.
/// All content cards in NomadAir use this as the outer container.
final class NomadCard extends StatelessWidget {
  const NomadCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.semanticLabel,
  });

  final Widget  child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      container: true,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}
