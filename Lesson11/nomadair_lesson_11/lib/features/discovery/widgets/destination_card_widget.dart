import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../models/destination_model.dart';

final class DestinationCardWidget extends StatelessWidget {
  const DestinationCardWidget({super.key,required this.destination,this.onTap});
  final DiscoveryDestination destination;
  final VoidCallback?        onTap;

  @override Widget build(BuildContext context){
    final t=Theme.of(context).extension<NomadThemeExtension>()!;
    return MergeSemantics(child:Semantics(
      label:'${destination.city}, ${destination.country}. ${destination.tagline}. ${destination.formattedPrice}.',
      button:onTap!=null,
      child:Card(clipBehavior:Clip.antiAlias,
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(AppSpacing.radiusMd)),
        child:InkWell(onTap:onTap,child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,children:[
            ColorFiltered(colorFilter:ColorFilter.mode(t.imageOverlayColor,BlendMode.srcATop),
              child:ExcludeSemantics(child:CustomPaint(size:const Size(double.infinity,120),
                painter:_GP(top:Color(destination.skyColorTop),bottom:Color(destination.skyColorBottom),iata:destination.iataCode)))),
            Padding(padding:const EdgeInsets.all(AppSpacing.md),
              child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
                  Text(destination.city,style:AppTypography.headlineSmall),
                  if(destination.isTrending)Container(
                    padding:const EdgeInsets.symmetric(horizontal:AppSpacing.sm,vertical:2),
                    decoration:BoxDecoration(color:t.brandAccent.withAlpha(28),
                      borderRadius:BorderRadius.circular(AppSpacing.radiusFull),
                      border:Border.all(color:t.brandAccent.withAlpha(100))),
                    child:Text('#${destination.trendingRank}',style:AppTypography.monoSmall.copyWith(
                      color:t.brandAccent,fontWeight:FontWeight.w700))),
                ]),
                Text(destination.tagline,style:AppTypography.bodySmall.copyWith(
                  color:t.onSurfaceColor.withAlpha(150))),
                const SizedBox(height:AppSpacing.xs),
                Text(destination.formattedPrice,style:AppTypography.labelLarge.copyWith(
                  color:t.brandPrimary,fontWeight:FontWeight.w700)),
              ])),
          ])))));
  }
}
class _GP extends CustomPainter{
  const _GP({required this.top,required this.bottom,required this.iata});
  final Color top,bottom;final String iata;
  @override void paint(Canvas c,Size s){
    final r=Offset.zero&s;
    c.drawRect(r,Paint()..shader=LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[top,bottom]).createShader(r));
    final tp=TextPainter(text:TextSpan(text:iata,style:TextStyle(color:Colors.white.withAlpha(35),fontSize:56,fontWeight:FontWeight.w900,fontFamily:'monospace')),textDirection:TextDirection.ltr)..layout();
    tp.paint(c,Offset(s.width-tp.width-8,s.height/2-tp.height/2));
  }
  @override bool shouldRepaint(_GP o)=>o.top!=top||o.bottom!=bottom;
}
