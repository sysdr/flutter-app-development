import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

sealed class ButtonVariant{const ButtonVariant();}
final class FilledVariant   extends ButtonVariant{const FilledVariant();}
final class OutlinedVariant extends ButtonVariant{const OutlinedVariant();}
final class GhostVariant    extends ButtonVariant{const GhostVariant();}

/// NomadAir primary button.
///
/// Lesson 08 — Full semantic annotation:
///   [Semantics.label]   — screen-reader description
///   [Semantics.button]  — marks as interactive button
///   [Semantics.enabled] — reflects disabled state to accessibility
///   [MergeSemantics]    — merges icon + label into single announcement
final class NomadButton extends StatelessWidget {
  const NomadButton({
    super.key,required this.label,required this.onPressed,
    this.variant=const FilledVariant(),this.loading=false,
    this.icon,this.semanticLabel,
  });
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool loading;
  final IconData? icon;
  final String? semanticLabel;

  Widget _child()=>loading
    ?const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2.5))
    :icon!=null
      ?Row(mainAxisSize:MainAxisSize.min,children:[
          ExcludeSemantics(child:Icon(icon,size:18)),
          const SizedBox(width:AppSpacing.sm),
          Text(label,style:AppTypography.labelLarge),
        ])
      :Text(label,style:AppTypography.labelLarge);

  @override
  Widget build(BuildContext context){
    final t=Theme.of(context).extension<NomadThemeExtension>()!;
    final cb=loading?null:onPressed;
    final minSz=WidgetStateProperty.all(
      const Size(double.infinity,AppSpacing.minTouchTarget));
    final shape=WidgetStateProperty.all(RoundedRectangleBorder(
      borderRadius:BorderRadius.circular(AppSpacing.radiusMd)));

    return MergeSemantics(
      child:Semantics(
        label:semanticLabel??label,
        button:true,
        enabled:cb!=null,
        child:switch(variant){
          FilledVariant()=>FilledButton(
            style:FilledButton.styleFrom(
              backgroundColor:t.brandPrimary,foregroundColor:AppColors.white,
              minimumSize:const Size(double.infinity,AppSpacing.minTouchTarget),
              shape:RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(AppSpacing.radiusMd))),
            onPressed:cb,child:_child()),
          OutlinedVariant()=>OutlinedButton(
            style:OutlinedButton.styleFrom(
              foregroundColor:t.brandPrimary,
              side:BorderSide(color:t.brandPrimary.withAlpha(180)),
              minimumSize:const Size(double.infinity,AppSpacing.minTouchTarget),
              shape:RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(AppSpacing.radiusMd))),
            onPressed:cb,child:_child()),
          GhostVariant()=>TextButton(
            style:ButtonStyle(minimumSize:minSz,shape:shape),
            onPressed:cb,child:_child()),
        },
      ),
    );
  }
}
