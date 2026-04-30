import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../router/navigator_routes.dart';
import '../models/destination_model.dart';
import '../widgets/filter_chip_bar_widget.dart';
import '../widgets/destination_card_widget.dart';

sealed class _FS{const _FS();}
final class _Loading extends _FS{const _Loading();}
final class _Loaded extends _FS{const _Loaded(this.items,this.filter);final List<DiscoveryDestination> items;final DiscoveryFilter filter;}
final class _Error extends _FS{const _Error(this.msg);final String msg;}

final class DiscoveryFeedScreen extends StatefulWidget{const DiscoveryFeedScreen({super.key});@override State<DiscoveryFeedScreen> createState()=>_DiscoveryFeedScreenState();}
final class _DiscoveryFeedScreenState extends State<DiscoveryFeedScreen> with SingleTickerProviderStateMixin{
  late final AnimationController _sh;_FS _state=const _Loading();DiscoveryFilter _filter=DiscoveryFilter.all;bool _pv=false;
  late final PageController _pc;int _pi=0;
  @override void initState(){super.initState();_pc=PageController();_sh=AnimationController(vsync:this,duration:const Duration(milliseconds:1400))..repeat();_load();}
  @override void dispose(){_sh.dispose();_pc.dispose();super.dispose();}
  Future<void> _load()async{setState(()=>_state=const _Loading());await Future<void>.delayed(const Duration(milliseconds:1200));if(!mounted)return;setState(()=>_state=_Loaded(DiscoveryDestination.samples,_filter));}
  List<DiscoveryDestination> get _flt{if(_state is! _Loaded)return[];final all=(_state as _Loaded).items;return switch(_filter){DiscoveryFilter.all=>all,DiscoveryFilter.flights=>all.where((d)=>d.category=='flights'||d.category=='both').toList(),DiscoveryFilter.hotels=>all.where((d)=>d.category=='hotels'||d.category=='both').toList()};}
  @override Widget build(BuildContext ctx){
    final t=Theme.of(ctx).extension<NomadThemeExtension>()!;
    return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Padding(padding:const EdgeInsets.fromLTRB(AppSpacing.md,AppSpacing.md,AppSpacing.md,0),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[Expanded(child:Text('Discover',style:AppTypography.displayLarge.copyWith(color:t.onSurfaceColor))),IconButton(icon:Icon(_pv?Icons.grid_view_outlined:Icons.view_day_outlined),onPressed:()=>setState(()=>_pv=!_pv))]),
        AnimatedOpacity(
          opacity: _state is _Loading ? 0.4 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: FilterChipBarWidget(
            active: _filter,
            onChanged: _state is _Loading
                ? (_) {}
                : (f) {
                    setState(() {
                      _filter = f;
                      if (_state is _Loaded) {
                        _state = _Loaded((_state as _Loaded).items, f);
                      }
                    });
                  },
          ),
        ),
      ])),
      const SizedBox(height:AppSpacing.sm),
      Expanded(child:AnimatedSwitcher(duration:const Duration(milliseconds:300),child:KeyedSubtree(key:ValueKey('${_state.runtimeType}-$_pv-$_filter'),child:switch(_state){
        _Loading()=>_sGrid(),
        _Loaded()=>_pv?_pView():_grid(),
        _Error(:final msg)=>Center(child:NomadButton(label:'Retry',icon:Icons.refresh,onPressed:_load)),
      })))]);
  }
  Widget _sGrid(){return LayoutBuilder(builder:(ctx,cs){final c=cs.maxWidth>=576?2:1;return GridView.builder(padding:const EdgeInsets.fromLTRB(AppSpacing.md,0,AppSpacing.md,AppSpacing.xl),gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:c,mainAxisSpacing:AppSpacing.md,crossAxisSpacing:AppSpacing.md,childAspectRatio:c==1?1.4:0.85),itemCount:DiscoveryDestination.samples.length,itemBuilder:(_,__)=>DiscoveryCardShimmer(animation:_sh));});}
  Widget _grid(){final it=_flt;return LayoutBuilder(builder:(ctx,cs){final c=cs.maxWidth>=576?2:1;return GridView.builder(cacheExtent:500,padding:const EdgeInsets.fromLTRB(AppSpacing.md,0,AppSpacing.md,AppSpacing.xl),gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:c,mainAxisSpacing:AppSpacing.md,crossAxisSpacing:AppSpacing.md,childAspectRatio:c==1?1.4:0.85),itemCount:it.length,itemBuilder:(_,i)=>DestinationCardWidget(key:ValueKey(it[i].id),destination:it[i],onTap:()=>context.go(NavigatorRoutes.destinationDetail,extra:it[i])));});}
  Widget _pView(){final it=_flt;return PageView.builder(controller:_pc,scrollDirection:Axis.vertical,itemCount:it.length,onPageChanged:(i)=>setState(()=>_pi=i),itemBuilder:(_,i)=>DiscoveryCardFull(key:ValueKey(it[i].id),destination:it[i],onBook:()=>context.go(NavigatorRoutes.destinationDetail,extra:it[i])));}
}
