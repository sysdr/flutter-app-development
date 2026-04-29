import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
final class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key, this.criteria});
  final dynamic criteria;
  static const List<FlightModel> _m=[FlightModel(id:'AI-101',airline:'Air India',origin:'BOM',destination:'DXB',durationMinutes:215,priceInr:18500,stops:0),FlightModel(id:'EK-501',airline:'Emirates',origin:'BOM',destination:'DXB',durationMinutes:200,priceInr:22000,stops:0)];
  @override Widget build(BuildContext ctx)=>Scaffold(appBar:AppBar(title:const Text('Results'),surfaceTintColor:Colors.transparent,leading:BackButton(onPressed:()=>ctx.pop())),body:ListView(padding:const EdgeInsets.all(AppSpacing.md),children:_m.map((f)=>Padding(padding:const EdgeInsets.only(bottom:AppSpacing.md),child:NomadFlightCard(flight:f,onTap:()=>ctx.pop()))).toList()));
}
