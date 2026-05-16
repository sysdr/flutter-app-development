import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../core/transitions/hero_tags.dart';
import '../../../router/navigator_routes.dart';
import '../models/destination_model.dart';
final class DestinationDetailScreen extends StatelessWidget{const DestinationDetailScreen({super.key,required this.destination});final DiscoveryDestination destination;@override Widget build(BuildContext context){final t=Theme.of(context).extension<NomadThemeExtension>()!;return Scaffold(appBar:AppBar(title:Text(destination.city),surfaceTintColor:Colors.transparent,leading:BackButton(onPressed:()=>context.pop())),body:ListView(padding:const EdgeInsets.all(AppSpacing.md),children:[Hero(tag:HeroTags.destinationImage(destination.iataCode),child:Container(height:180,decoration:BoxDecoration(color:t.brandPrimary.withAlpha(30),borderRadius:BorderRadius.circular(AppSpacing.radiusMd)),child:Center(child:Text(destination.iataCode,style:AppTypography.displayLarge.copyWith(color:t.brandPrimary,fontSize:56,fontWeight:FontWeight.w800))))),const SizedBox(height:AppSpacing.md),Text(destination.city,style:AppTypography.displayLarge.copyWith(color:t.onSurfaceColor)),Text(destination.tagline,style:AppTypography.bodyLarge.copyWith(color:t.onSurfaceColor.withAlpha(180))),const SizedBox(height:AppSpacing.xl),NomadButton(label:'Search Flights',icon:Icons.flight_takeoff,onPressed:()=>context.go(NavigatorRoutes.search)),const SizedBox(height:AppSpacing.sm),NomadButton(label:'Back',variant:const OutlinedVariant(),onPressed:()=>context.pop())]));}
}
