import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../router/navigator_routes.dart';
import '../models/search_criteria.dart';
import '../state/search_state.dart';

final class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override State<SearchScreen> createState() => _SearchScreenState();
}

final class _SearchScreenState extends State<SearchScreen> {
  final _originCtrl = TextEditingController();
  final _destCtrl   = TextEditingController();
  SearchState _state = const SearchState();

  @override void dispose(){_originCtrl.dispose();_destCtrl.dispose();super.dispose();}

  Future<void> _submit() async {
    final emptyOrigin = _originCtrl.text.trim().isEmpty;
    final emptyDest   = _destCtrl.text.trim().isEmpty;
    if (emptyOrigin || emptyDest) {
      setState(() => _state = _state.copyWith(
        error: 'Enter both cities'));
      return;
    }
    setState(() => _state = _state.copyWith(loading: true, error: null));
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final criteria = SearchCriteria(
      origin:      _originCtrl.text.trim(),
      destination: _destCtrl.text.trim(),
      departureDate: DateTime.now().add(const Duration(days: 7)),
    );
    // Pass criteria as typed extra — received in SearchResultsScreen
    context.push(NavigatorRoutes.searchResults, extra: criteria);
    setState(() => _state = _state.copyWith(loading: false));
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Search Flights',style:AppTypography.displayLarge.copyWith(
          color:t.onSurfaceColor)),
        const SizedBox(height:AppSpacing.xs),
        Text('context.push with SearchCriteria extra',
          style:AppTypography.bodySmall.copyWith(
            color:t.onSurfaceColor.withAlpha(140))),
        const SizedBox(height:AppSpacing.xl),
        NomadTextField(label:'Departure City',hint:'Mumbai (BOM)',
          prefixIcon:Icons.flight_takeoff,controller:_originCtrl,
          error:_state.error!=null&&_originCtrl.text.isEmpty?_state.error:null),
        const SizedBox(height:AppSpacing.md),
        NomadTextField(label:'Destination',hint:'Dubai (DXB)',
          prefixIcon:Icons.flight_land,controller:_destCtrl,
          error:_state.error!=null&&_destCtrl.text.isEmpty?_state.error:null),
        const SizedBox(height:AppSpacing.lg),
        NomadButton(label:'Search Flights',icon:Icons.search,
          loading:_state.loading,
          onPressed:_state.loading?null:_submit),
      ]),
    );
  }
}
