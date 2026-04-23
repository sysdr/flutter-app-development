import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

/// Flight result card — Lesson 08 focus component.
///
/// Demonstrates the [MergeSemantics] pattern for complex content cards:
///   - All child text nodes merged into a single semantic node
///   - [Semantics.label] provides a coherent one-shot TalkBack announcement
///   - Decorative icons excluded via [ExcludeSemantics]
///   - [Semantics.button] marks the whole card as tappable
///
/// TalkBack announces: "Air India, BOM to DEL, ₹4200, Non-stop, 2h 5m. Button."
final class NomadFlightCard extends StatelessWidget {
  const NomadFlightCard({
    super.key,
    required this.flight,
    this.onTap,
  });

  final FlightModel flight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context){
    final t=Theme.of(context).extension<NomadThemeExtension>()!;

    return MergeSemantics(
      child:Semantics(
        label:flight.accessibilityLabel,
        button:onTap!=null,
        child:Card(
          child:InkWell(
            onTap:onTap,
            borderRadius:BorderRadius.circular(AppSpacing.radiusMd),
            child:Padding(
              padding:const EdgeInsets.all(AppSpacing.md),
              child:Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:[
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children:[
                      // ExcludeSemantics: icon decoration — label carries the info
                      ExcludeSemantics(
                        child:Icon(Icons.flight_takeoff,size:16,
                          color:t.onSurfaceColor.withAlpha(160))),
                      const SizedBox(width:AppSpacing.sm),
                      Expanded(
                        child:Text(flight.airline,
                          style:AppTypography.labelLarge)),
                      Text(flight.formattedPrice,
                        style:AppTypography.headlineSmall.copyWith(
                          color:t.brandPrimary,fontWeight:FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height:AppSpacing.xs),
                  Text(flight.route,
                    style:AppTypography.headlineMedium),
                  const SizedBox(height:AppSpacing.xs),
                  Row(children:[
                    Text(flight.formattedDuration,
                      style:AppTypography.bodySmall.copyWith(
                        color:t.onSurfaceColor.withAlpha(160))),
                    const SizedBox(width:AppSpacing.md),
                    ExcludeSemantics(
                      child:Icon(Icons.circle,size:4,
                        color:t.onSurfaceColor.withAlpha(80))),
                    const SizedBox(width:AppSpacing.md),
                    Text(flight.stopsLabel,
                      style:AppTypography.bodySmall.copyWith(
                        color:t.onSurfaceColor.withAlpha(160))),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
