import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../routes/navigator_routes.dart';
import '../models/search_criteria.dart';
import '../state/search_state.dart';

/// Search **screen** — flight search form.
///
/// L10: basic form with validation.
/// L14: adds CityPicker, DateRangePicker, PassengerSelector widgets.
final class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final class _SearchScreenState extends State<SearchScreen> {
  final _originCtrl = TextEditingController();
  final _destCtrl   = TextEditingController();
  SearchState _state = const SearchState();

  @override
  void dispose(){ _originCtrl.dispose(); _destCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    final empty = _originCtrl.text.trim().isEmpty ||
                  _destCtrl.text.trim().isEmpty;
    if (empty) {
      setState(() => _state = _state.copyWith(
        error: 'Enter both departure and destination cities'));
      return;
    }
    setState(() => _state = _state.copyWith(loading: true, error: null));
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _state = _state.copyWith(loading: false));
    Navigator.of(context).pushNamed(NavigatorRoutes.searchResults);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Search Flights',style:AppTypography.displayLarge.copyWith(
            color:t.onSurfaceColor)),
          const SizedBox(height:AppSpacing.xs),
          Text('search/screens/ · L14 adds CityPicker + DateRangePicker',
            style:AppTypography.bodySmall.copyWith(
              color:t.onSurfaceColor.withAlpha(140))),
          const SizedBox(height:AppSpacing.xl),
          NomadTextField(label:'Departure City',hint:'Mumbai (BOM)',
            prefixIcon:Icons.flight_takeoff,controller:_originCtrl,
            error:_state.error!=null&&_originCtrl.text.isEmpty
                ?_state.error:null),
          const SizedBox(height:AppSpacing.md),
          NomadTextField(label:'Destination',hint:'Dubai (DXB)',
            prefixIcon:Icons.flight_land,controller:_destCtrl,
            error:_state.error!=null&&_destCtrl.text.isEmpty
                ?_state.error:null),
          const SizedBox(height:AppSpacing.lg),
          NomadButton(label:'Search Flights',icon:Icons.search,
            loading:_state.loading,
            onPressed:_state.loading?null:_submit),
        ]),
      ),
    );
  }
}
