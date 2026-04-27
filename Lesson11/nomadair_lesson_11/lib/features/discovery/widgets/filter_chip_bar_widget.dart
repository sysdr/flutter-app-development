import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../models/destination_model.dart';

final class FilterChipBarWidget extends StatelessWidget {
  const FilterChipBarWidget({super.key,required this.active,required this.onChanged});
  final DiscoveryFilter             active;
  final ValueChanged<DiscoveryFilter> onChanged;
  @override Widget build(BuildContext context)=>Wrap(
    spacing:AppSpacing.sm,
    children:DiscoveryFilter.values.map((f){
      final label=switch(f){DiscoveryFilter.all=>'All',DiscoveryFilter.flights=>'Flights',DiscoveryFilter.hotels=>'Hotels'};
      return NomadChip(label:label,variant:const FilterChipVariant(),
        selected:active==f,semanticLabel:'$label filter${active==f?", selected":""}',
        onTap:()=>onChanged(f));
    }).toList());
}
