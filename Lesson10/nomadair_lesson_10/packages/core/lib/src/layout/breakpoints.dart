import 'package:flutter/material.dart';
sealed class NavigationStyle{const NavigationStyle();}
final class CompactNav  extends NavigationStyle{const CompactNav();}
final class MediumNav   extends NavigationStyle{const MediumNav();}
final class ExpandedNav extends NavigationStyle{const ExpandedNav();}
abstract final class Breakpoints{
  static const double compact=600.0,medium=840.0;
  static NavigationStyle styleFor(double w){
    if(w>=medium)return const ExpandedNav();
    if(w>=compact)return const MediumNav();
    return const CompactNav();}
  static bool isLandscape(BuildContext c)=>MediaQuery.orientationOf(c)==Orientation.landscape;
}
