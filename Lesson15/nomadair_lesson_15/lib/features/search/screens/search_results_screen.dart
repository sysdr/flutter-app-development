import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../models/search_criteria.dart';
final class SearchResultsScreen extends StatelessWidget{const SearchResultsScreen({super.key,this.criteria});final SearchCriteria? criteria;static final _f=DateFormat('dd MMM');static const List<FlightModel> _m=[FlightModel(id:'AI-101',airline:'Air India',origin:'BOM',destination:'DXB',durationMinutes:215,priceInr:18500,stops:0),FlightModel(id:'EK-501',airline:'Emirates',origin:'BOM',destination:'DXB',durationMinutes:200,priceInr:22000,stops:0),FlightModel(id:'IX-251',airline:'Air Arabia',origin:'BOM',destination:'DXB',durationMinutes:240,priceInr:14200,stops:1)];@override Widget build(BuildContext ctx){final t=Theme.of(ctx).extension<NomadThemeExtension>()!;final c=criteria;final title=c?.origin!=null&&c?.destination!=null?'${c!.origin!.iata} → ${c.destination!.iata}':'Results';return Scaffold(appBar:AppBar(title:Text(title),surfaceTintColor:Colors.transparent,leading:BackButton(onPressed:()=>ctx.pop())),body:ListView.separated(padding:const EdgeInsets.all(AppSpacing.md),itemCount:_m.length,separatorBuilder:(_,__)=>const SizedBox(height:AppSpacing.md),itemBuilder:(_,i)=>NomadFlightCard(flight:_m[i],onTap:()=>{})));}}
