import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

final class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'),
        surfaceTintColor: Colors.transparent),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ExcludeSemantics(child:Icon(Icons.settings_outlined,size:80,
            color: t.brandPrimary.withAlpha(120))),
          const SizedBox(height: AppSpacing.lg),
          Text('SettingsScreen',style:AppTypography.headlineLarge.copyWith(
            color:t.onSurfaceColor)),
          const SizedBox(height:AppSpacing.xs),
          Text('profile/screens/',style:AppTypography.monoSmall.copyWith(
            color:t.onSurfaceColor.withAlpha(140))),
          const SizedBox(height:AppSpacing.xs),
          Text('L07 theme persist  L34 currency pref  L29 notifications',style:AppTypography.bodySmall.copyWith(
            color:t.onSurfaceColor.withAlpha(120)),
            textAlign:TextAlign.center),
          const SizedBox(height:AppSpacing.xl),
          SizedBox(width:180,child:NomadButton(label:'Back',
            variant:const OutlinedVariant(),
            onPressed:()=>Navigator.of(context).pop())),
        ]),
      ),
    );
  }
}
