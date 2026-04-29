import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
final class AdaptiveDestination{const AdaptiveDestination({required this.icon,required this.selectedIcon,required this.label,required this.semanticLabel,required this.builder});final IconData icon,selectedIcon;final String label,semanticLabel;final WidgetBuilder builder;}
final class AdaptiveScaffold extends StatefulWidget{
  const AdaptiveScaffold({super.key,required this.destinations,this.title,this.actions,this.initialIndex=0,this.onTabChange}):assert(destinations.length>=2);
  final List<AdaptiveDestination> destinations;final String? title;final List<Widget>? actions;final int initialIndex;final ValueChanged<int>? onTabChange;
  @override State<AdaptiveScaffold> createState()=>_S();
}
final class _S extends State<AdaptiveScaffold>{
  late int _idx;
  @override void initState(){super.initState();_idx=widget.initialIndex;}
  @override void didUpdateWidget(AdaptiveScaffold oldWidget){
    super.didUpdateWidget(oldWidget);
    if(widget.initialIndex!=oldWidget.initialIndex){setState(()=>_idx=widget.initialIndex);}
  }
  void _sel(int i){if(i!=_idx){setState(()=>_idx=i);widget.onTabChange?.call(i);}}
  List<NavigationDestination> get _bar=>widget.destinations.map((d)=>NavigationDestination(icon:Icon(d.icon),selectedIcon:Icon(d.selectedIcon),label:d.label)).toList();
  List<NavigationRailDestination> get _rail=>widget.destinations.map((d)=>NavigationRailDestination(icon:Icon(d.icon),selectedIcon:Icon(d.selectedIcon),label:Text(d.label))).toList();
  @override Widget build(BuildContext c)=>LayoutBuilder(builder:(ctx,cs){
    final style=Breakpoints.styleFor(cs.maxWidth);
    final body=widget.destinations[_idx].builder(ctx);
    return AnimatedSwitcher(duration:const Duration(milliseconds:200),child:KeyedSubtree(key:ValueKey(style.runtimeType),child:switch(style){CompactNav()=>_mob(body),MediumNav()=>_wide(body,false),ExpandedNav()=>_wide(body,true)}));
  });
  Widget _mob(Widget body)=>Scaffold(appBar:_bar2(),body:body,bottomNavigationBar:NavigationBar(selectedIndex:_idx,onDestinationSelected:_sel,destinations:_bar,height:64));
  Widget _wide(Widget body,bool ext)=>Scaffold(appBar:_bar2(),body:Row(children:[NavigationRail(extended:ext,selectedIndex:_idx,onDestinationSelected:_sel,destinations:_rail,useIndicator:true,minWidth:72,minExtendedWidth:180),const VerticalDivider(thickness:1,width:1),Expanded(child:body)]));
  AppBar _bar2(){final t=Theme.of(context).extension<NomadThemeExtension>()!;return AppBar(title:Text(widget.title??'NomadAir',style:AppTypography.headlineMedium.copyWith(color:t.onSurfaceColor)),actions:widget.actions,surfaceTintColor:Colors.transparent);}
}
