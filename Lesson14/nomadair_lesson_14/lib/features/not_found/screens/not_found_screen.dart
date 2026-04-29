import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../router/navigator_routes.dart';
final class NotFoundScreen extends StatelessWidget{
  const NotFoundScreen({super.key,required this.location});final String location;
  @override Widget build(BuildContext context){
    final t=Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(appBar:AppBar(title:const Text('Not Found'),surfaceTintColor:Colors.transparent),
      body:Center(child:Padding(padding:const EdgeInsets.all(AppSpacing.xl),child:Column(mainAxisSize:MainAxisSize.min,children:[
        ExcludeSemantics(child:Icon(Icons.error_outline,size:72,color:t.errorColor.withAlpha(160))),
        const SizedBox(height:AppSpacing.lg),
        Text('404 — Not Found',style:AppTypography.headlineLarge.copyWith(color:t.onSurfaceColor)),
        const SizedBox(height:AppSpacing.xl),
        SizedBox(width:220,child:NomadButton(label:'Go to Discovery',icon:Icons.explore,onPressed:()=>context.go(NavigatorRoutes.discovery))),
      ]))));
  }
}
