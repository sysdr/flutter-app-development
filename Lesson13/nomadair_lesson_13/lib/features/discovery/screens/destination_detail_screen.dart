import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../router/navigator_routes.dart';
import '../models/destination_model.dart';

final class DestinationDetailScreen extends StatelessWidget {
  const DestinationDetailScreen({super.key, required this.destination});
  final DiscoveryDestination destination;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(title: Text(destination.city),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop())),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
        ClipRRect(borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: CustomPaint(size: const Size(double.infinity, 200),
            painter: _HP(top: Color(destination.skyColorTop),
              bottom: Color(destination.skyColorBottom),
              iata: destination.iataCode))),
        const SizedBox(height: AppSpacing.lg),
        Text(destination.city, style: AppTypography.displayLarge.copyWith(color: t.onSurfaceColor)),
        Text(destination.country, style: AppTypography.headlineMedium.copyWith(color: t.onSurfaceColor.withAlpha(160))),
        const SizedBox(height: AppSpacing.sm),
        Text(destination.tagline, style: AppTypography.bodyLarge.copyWith(color: t.onSurfaceColor.withAlpha(180))),
        const SizedBox(height: AppSpacing.md),
        Text(destination.formattedPrice, style: AppTypography.headlineMedium.copyWith(color: t.brandPrimary, fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.xl),
        NomadButton(label: 'Search Flights', icon: Icons.flight_takeoff, onPressed: () => context.go(NavigatorRoutes.search)),
        const SizedBox(height: AppSpacing.sm),
        NomadButton(label: 'Back', variant: const OutlinedVariant(), onPressed: () => context.pop()),
      ]));
  }
}
class _HP extends CustomPainter{const _HP({required this.top,required this.bottom,required this.iata});final Color top,bottom;final String iata;@override void paint(Canvas c,Size s){final r=Offset.zero&s;c.drawRect(r,Paint()..shader=LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[top,bottom]).createShader(r));final tp=TextPainter(text:TextSpan(text:iata,style:TextStyle(color:Colors.white.withAlpha(35),fontSize:80,fontWeight:FontWeight.w900,fontFamily:'monospace')),textDirection:TextDirection.ltr)..layout();tp.paint(c,Offset(s.width-tp.width-12,s.height/2-tp.height/2));}@override bool shouldRepaint(_HP o)=>o.top!=top||o.bottom!=bottom;}
