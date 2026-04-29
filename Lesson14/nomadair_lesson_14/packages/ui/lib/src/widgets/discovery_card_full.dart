import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
final class DiscoveryCardFull extends StatelessWidget{
  const DiscoveryCardFull({super.key,required this.city,required this.country,required this.iataCode,required this.priceText,required this.skyColorTop,required this.skyColorBottom,this.onBook});
  final String city,country,iataCode,priceText;final int skyColorTop,skyColorBottom;final VoidCallback? onBook;
  @override Widget build(BuildContext context){
    final t=Theme.of(context).extension<NomadThemeExtension>()!;
    return Stack(fit:StackFit.expand,children:[
      ColorFiltered(colorFilter:ColorFilter.mode(t.imageOverlayColor,BlendMode.srcATop),child:CustomPaint(painter:_P(top:Color(skyColorTop),bottom:Color(skyColorBottom),iata:iataCode))),
      Positioned(left:0,right:0,bottom:0,child:Container(height:200,decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,Colors.black.withAlpha(200)])))),
      Positioned(left:AppSpacing.lg,right:AppSpacing.lg,bottom:AppSpacing.xl,child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisSize:MainAxisSize.min,children:[
        Text(city,style:AppTypography.displayLarge.copyWith(color:AppColors.white)),
        Text(country,style:AppTypography.headlineSmall.copyWith(color:AppColors.white.withAlpha(200))),
        const SizedBox(height:AppSpacing.sm),
        Text(priceText,style:AppTypography.headlineMedium.copyWith(color:AppColors.white,fontWeight:FontWeight.w700)),
        if(onBook!=null)...[const SizedBox(height:AppSpacing.md),SizedBox(width:160,child:FilledButton(style:FilledButton.styleFrom(backgroundColor:AppColors.white.withAlpha(230),foregroundColor:AppColors.grey900,minimumSize:const Size(0,AppSpacing.minTouchTarget),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(AppSpacing.radiusMd))),onPressed:onBook,child:const Text('Book Now')))],
      ])),
    ]);
  }
}
class _P extends CustomPainter{const _P({required this.top,required this.bottom,required this.iata});final Color top,bottom;final String iata;@override void paint(Canvas c,Size s){final r=Offset.zero&s;c.drawRect(r,Paint()..shader=LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[top,bottom]).createShader(r));final tp=TextPainter(text:TextSpan(text:iata,style:TextStyle(color:Colors.white.withAlpha(30),fontSize:140,fontWeight:FontWeight.w900,fontFamily:'monospace')),textDirection:TextDirection.ltr)..layout();tp.paint(c,Offset(s.width/2-tp.width/2,s.height/2-tp.height/2));}@override bool shouldRepaint(_P o)=>o.top!=top||o.bottom!=bottom;}
