import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

final class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),
        surfaceTintColor: Colors.transparent),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ExcludeSemantics(child:Icon(Icons.person_outline,size:80,
            color: t.brandPrimary.withAlpha(120))),
          const SizedBox(height: AppSpacing.lg),
          Text('ProfileScreen',style:AppTypography.headlineLarge.copyWith(
            color:t.onSurfaceColor)),
          const SizedBox(height:AppSpacing.xs),
          Text('profile/screens/',style:AppTypography.monoSmall.copyWith(
            color:t.onSurfaceColor.withAlpha(140))),
          const SizedBox(height:AppSpacing.xs),
          Text('L25: Firebase Auth  L29: Biometric auth',style:AppTypography.bodySmall.copyWith(
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
