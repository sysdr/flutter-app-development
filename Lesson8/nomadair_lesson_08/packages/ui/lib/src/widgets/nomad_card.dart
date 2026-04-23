import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

sealed class CardVariant{const CardVariant();}
final class FlatCard     extends CardVariant{const FlatCard();}
final class ElevatedCard extends CardVariant{const ElevatedCard();}
final class OutlinedCard extends CardVariant{const OutlinedCard();}

/// NomadAir base card.
///
/// Lesson 08 — Full semantic annotation:
///   [MergeSemantics]   — merges card content into one semantic node
///   [Semantics.label]  — describes the card's purpose to screen readers
///   [Semantics.button] — set true when [onTap] is provided
///   Minimum touch target: 48dp enforced by [ConstrainedBox]
final class NomadCard extends StatelessWidget {
  const NomadCard({
    super.key,required this.child,
    this.variant=const ElevatedCard(),this.onTap,
    this.padding,this.semanticLabel,
  });
  final Widget child;
  final CardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context){
    final t=Theme.of(context).extension<NomadThemeExtension>()!;
    final (elev,border)=switch(variant){
      FlatCard()    =>(0.0,Border.all(color:Colors.transparent)),
      ElevatedCard()=>(2.0,Border.all(color:Colors.transparent)),
      OutlinedCard()=>(0.0,Border.all(color:t.brandPrimary.withAlpha(120),width:1.5)),
    };
    return MergeSemantics(
      child:Semantics(
        label:semanticLabel,
        container:true,
        button:onTap!=null,
        child:ConstrainedBox(
          constraints:const BoxConstraints(minHeight:AppSpacing.minTouchTarget),
          child:Material(
            color:t.surfaceColor,elevation:elev,
            borderRadius:BorderRadius.circular(AppSpacing.radiusMd),
            child:Container(
              decoration:BoxDecoration(border:border,
                borderRadius:BorderRadius.circular(AppSpacing.radiusMd)),
              child:InkWell(
                onTap:onTap,
                borderRadius:BorderRadius.circular(AppSpacing.radiusMd),
                child:Padding(
                  padding:padding??const EdgeInsets.all(AppSpacing.md),
                  child:child)),
            ),
          ),
        ),
      ),
    );
  }
}
