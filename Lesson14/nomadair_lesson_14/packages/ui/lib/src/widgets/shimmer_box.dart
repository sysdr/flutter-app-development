import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
final class ShimmerBox extends StatelessWidget{
  const ShimmerBox({super.key,required this.animation,required this.width,required this.height,this.borderRadius=AppSpacing.radiusSm});
  final Animation<double> animation;final double width,height,borderRadius;
  @override Widget build(BuildContext context){
    final isDark=Theme.of(context).brightness==Brightness.dark;
    final base=isDark?AppColors.darkElevated:AppColors.grey200;
    final hi=isDark?const Color(0xFF3A3A4E):AppColors.grey100;
    return AnimatedBuilder(animation:animation,builder:(_,__)=>CustomPaint(size:Size(width,height),painter:_SP(value:animation.value,base:base,highlight:hi,borderRadius:borderRadius)));
  }
}
final class _SP extends CustomPainter{const _SP({required this.value,required this.base,required this.highlight,required this.borderRadius});final double value,borderRadius;final Color base,highlight;@override void paint(Canvas c,Size s){final r=Offset.zero&s;final sweep=value*4-2;final g=LinearGradient(begin:Alignment(sweep-1,0),end:Alignment(sweep+1,0),colors:[base,highlight,base],stops:const [0.0,0.5,1.0]);c.drawRRect(RRect.fromRectAndRadius(r,Radius.circular(borderRadius)),Paint()..shader=g.createShader(r));}@override bool shouldRepaint(_SP o)=>o.value!=value||o.base!=base||o.highlight!=highlight;}
