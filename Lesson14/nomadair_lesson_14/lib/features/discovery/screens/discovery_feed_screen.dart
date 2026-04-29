import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../router/navigator_routes.dart';
import '../models/destination_model.dart';
import '../widgets/filter_chip_bar_widget.dart';
import '../widgets/destination_card_widget.dart';

enum _FeedMode { grid, pageView }
sealed class _FeedState{const _FeedState();}
final class _Loading extends _FeedState{const _Loading();}
final class _Loaded  extends _FeedState{const _Loaded(this.items,this.filter);final List<DiscoveryDestination> items;final DiscoveryFilter filter;}
final class _Error   extends _FeedState{const _Error(this.message);final String message;}

final class DiscoveryFeedScreen extends StatefulWidget{
  const DiscoveryFeedScreen({super.key});
  @override State<DiscoveryFeedScreen> createState()=>_DiscoveryFeedScreenState();
}

final class _DiscoveryFeedScreenState extends State<DiscoveryFeedScreen>
    with SingleTickerProviderStateMixin{
  late final AnimationController _shimmer;
  _FeedState _state=const _Loading();
  _FeedMode _mode=_FeedMode.grid;
  DiscoveryFilter _filter=DiscoveryFilter.all;
  late final PageController _pageCtrl;
  int _pageIndex=0;

  @override void initState(){super.initState();_pageCtrl=PageController();_shimmer=AnimationController(vsync:this,duration:const Duration(milliseconds:1400))..repeat();_loadFeed();}
  @override void dispose(){_shimmer.dispose();_pageCtrl.dispose();super.dispose();}

  Future<void> _loadFeed()async{setState(()=>_state=const _Loading());await Future<void>.delayed(const Duration(milliseconds:1200));if(!mounted)return;setState(()=>_state=_Loaded(DiscoveryDestination.samples,_filter));}

  List<DiscoveryDestination> get _filtered{if(_state is! _Loaded)return[];final all=(_state as _Loaded).items;return switch(_filter){DiscoveryFilter.all=>all,DiscoveryFilter.flights=>all.where((d)=>d.category=='flights'||d.category=='both').toList(),DiscoveryFilter.hotels=>all.where((d)=>d.category=='hotels'||d.category=='both').toList()};}

  @override Widget build(BuildContext context){
    final t=Theme.of(context).extension<NomadThemeExtension>()!;
    return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Padding(padding:const EdgeInsets.fromLTRB(AppSpacing.md,AppSpacing.md,AppSpacing.md,0),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[
          Expanded(child:Text('Discover',style:AppTypography.displayLarge.copyWith(color:t.onSurfaceColor))),
          IconButton(icon:Icon(_mode==_FeedMode.grid?Icons.view_day_outlined:Icons.grid_view_outlined),onPressed:()=>setState(()=>_mode=_mode==_FeedMode.grid?_FeedMode.pageView:_FeedMode.grid)),
        ]),
        AnimatedOpacity(opacity:_state is _Loading?0.4:1.0,duration:const Duration(milliseconds:300),
          child:FilterChipBarWidget(active:_filter,onChanged:_state is _Loading?(_){}:_onFilterChanged)),
      ])),
      const SizedBox(height:AppSpacing.sm),
      Expanded(child:AnimatedSwitcher(duration:const Duration(milliseconds:300),child:KeyedSubtree(key:ValueKey('${_state.runtimeType}-$_mode-$_filter'),child:_buildBody()))),
    ]);
  }

  void _onFilterChanged(DiscoveryFilter f){if(_state is! _Loaded)return;setState((){_filter=f;_state=_Loaded((_state as _Loaded).items,f);});}

  Widget _buildBody()=>switch(_state){
    _Loading()=>_shimmerGrid(),
    _Loaded()=>_mode==_FeedMode.grid?_grid():_pageView(),
    _Error(:final message)=>Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(Icons.wifi_off,size:64,color:Theme.of(context).extension<NomadThemeExtension>()!.errorColor.withAlpha(160)),const SizedBox(height:AppSpacing.lg),NomadButton(label:'Retry',icon:Icons.refresh,onPressed:_loadFeed)])),
  };

  Widget _shimmerGrid(){return LayoutBuilder(builder:(ctx,cs){final cols=cs.maxWidth>=576?2:1;return GridView.builder(padding:const EdgeInsets.fromLTRB(AppSpacing.md,0,AppSpacing.md,AppSpacing.xl),gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:cols,mainAxisSpacing:AppSpacing.md,crossAxisSpacing:AppSpacing.md,childAspectRatio:cols==1?1.4:0.85),itemCount:DiscoveryDestination.samples.length,itemBuilder:(_,__)=>DiscoveryCardShimmer(animation:_shimmer));});}

  Widget _grid(){final items=_filtered;return LayoutBuilder(builder:(ctx,cs){final cols=cs.maxWidth>=576?2:1;return GridView.builder(cacheExtent:500,padding:const EdgeInsets.fromLTRB(AppSpacing.md,0,AppSpacing.md,AppSpacing.xl),gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:cols,mainAxisSpacing:AppSpacing.md,crossAxisSpacing:AppSpacing.md,childAspectRatio:cols==1?1.4:0.85),itemCount:items.length,itemBuilder:(_,i)=>DestinationCardWidget(key:ValueKey(items[i].id),destination:items[i],onTap:()=>context.go(NavigatorRoutes.destinationDetail,extra:items[i])));});}

  Widget _pageView(){final items=_filtered;return PageView.builder(controller:_pageCtrl,scrollDirection:Axis.vertical,itemCount:items.length,onPageChanged:(i)=>setState(()=>_pageIndex=i),itemBuilder:(_,i)=>DiscoveryCardFull(key:ValueKey(items[i].id),city:items[i].city,country:items[i].country,iataCode:items[i].iataCode,priceText:items[i].formattedPrice,skyColorTop:items[i].skyColorTop,skyColorBottom:items[i].skyColorBottom,onBook:()=>context.go(NavigatorRoutes.destinationDetail,extra:items[i])));}
}
