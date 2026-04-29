import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../router/navigator_routes.dart';

final class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialOrigin, this.initialDestination});
  final String? initialOrigin, initialDestination;
  @override State<SearchScreen> createState() => _SS();
}
final class _SS extends State<SearchScreen> {
  late final TextEditingController _o, _d;
  bool _loading = false; String? _err;
  @override void initState(){super.initState();_o=TextEditingController(text:widget.initialOrigin??'');_d=TextEditingController(text:widget.initialDestination??'');}
  @override void dispose(){_o.dispose();_d.dispose();super.dispose();}
  Future<void> _submit() async {
    if(_o.text.trim().isEmpty||_d.text.trim().isEmpty){setState(()=>_err='Enter both cities');return;}
    setState(()=>_loading=true);await Future<void>.delayed(const Duration(milliseconds:600));
    if(!mounted)return;context.push(NavigatorRoutes.searchResults);setState(()=>_loading=false);
  }
  @override Widget build(BuildContext ctx){
    final t=Theme.of(ctx).extension<NomadThemeExtension>()!;
    return SingleChildScrollView(padding:const EdgeInsets.all(AppSpacing.md),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('Search Flights',style:AppTypography.displayLarge.copyWith(color:t.onSurfaceColor)),
      const SizedBox(height:AppSpacing.xl),
      NomadTextField(label:'Departure City',hint:'Mumbai (BOM)',prefixIcon:Icons.flight_takeoff,controller:_o,error:_err!=null&&_o.text.isEmpty?_err:null),
      const SizedBox(height:AppSpacing.md),
      NomadTextField(label:'Destination',hint:'Dubai (DXB)',prefixIcon:Icons.flight_land,controller:_d,error:_err!=null&&_d.text.isEmpty?_err:null),
      const SizedBox(height:AppSpacing.lg),
      NomadButton(label:'Search Flights',icon:Icons.search,loading:_loading,onPressed:_loading?null:_submit),
    ]));
  }
}
