import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

final class AdaptiveDestination {
  const AdaptiveDestination({required this.icon,required this.selectedIcon,
    required this.label,required this.builder});
  final IconData icon,selectedIcon;
  final String label;
  final WidgetBuilder builder;
}

final class AdaptiveScaffold extends StatefulWidget {
  const AdaptiveScaffold({super.key,required this.destinations,
    this.title,this.actions,this.forceStyle})
      : assert(destinations.length>=2);
  final List<AdaptiveDestination> destinations;
  final String? title;
  final List<Widget>? actions;
  final NavigationStyle? forceStyle;

  @override
  State<AdaptiveScaffold> createState()=>_State();
}

final class _State extends State<AdaptiveScaffold>{
  int _idx=0;
  void _sel(int i){if(i!=_idx)setState(()=>_idx=i);}

  List<NavigationDestination> get _barItems=>widget.destinations
    .map((d)=>NavigationDestination(
      icon:Icon(d.icon),selectedIcon:Icon(d.selectedIcon),label:d.label))
    .toList();

  List<NavigationRailDestination> get _railItems=>widget.destinations
    .map((d)=>NavigationRailDestination(
      icon:Icon(d.icon),selectedIcon:Icon(d.selectedIcon),label:Text(d.label)))
    .toList();

  @override
  Widget build(BuildContext c){
    return LayoutBuilder(builder:(ctx,cs){
      final style=widget.forceStyle??Breakpoints.styleFor(cs.maxWidth);
      final body=widget.destinations[_idx].builder(ctx);
      return AnimatedSwitcher(duration:const Duration(milliseconds:200),
        child:KeyedSubtree(key:ValueKey(style.runtimeType),
          child:switch(style){
            CompactNav()=>_mobile(body),
            MediumNav()=>_wide(body,false),
            ExpandedNav()=>_wide(body,true),
          }));
    });
  }

  Widget _mobile(Widget body)=>Scaffold(
    appBar:_bar(),body:body,
    bottomNavigationBar:NavigationBar(
      selectedIndex:_idx,onDestinationSelected:_sel,
      destinations:_barItems,height:64));

  Widget _wide(Widget body,bool ext)=>Scaffold(
    appBar:_bar(),
    body:Row(children:[
      NavigationRail(extended:ext,selectedIndex:_idx,
        onDestinationSelected:_sel,destinations:_railItems,
        useIndicator:true,minWidth:72,minExtendedWidth:180),
      const VerticalDivider(thickness:1,width:1),
      Expanded(child:body),
    ]));

  AppBar _bar(){
    final t=Theme.of(context).extension<NomadThemeExtension>()!;
    return AppBar(
      title:Text(widget.title??'NomadAir',
        style:AppTypography.headlineMedium.copyWith(color:t.onSurfaceColor)),
      actions:widget.actions,surfaceTintColor:Colors.transparent);
  }
}
