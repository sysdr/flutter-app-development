import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../models/destination_model.dart';

/// Destination detail **screen**.
///
/// Receives a [DiscoveryDestination] via route arguments.
/// In Lesson 49, this becomes the Hero animation destination.
final class DestinationDetailScreen extends StatelessWidget {
  const DestinationDetailScreen({super.key, required this.destination});

  final DiscoveryDestination destination;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.city),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Hero image area (CustomPaint placeholder)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: CustomPaint(
              size: const Size(double.infinity, 220),
              painter: _HeroPainter(
                top: Color(destination.skyColorTop),
                bottom: Color(destination.skyColorBottom),
                iata: destination.iataCode,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(destination.city,
            style: AppTypography.displayLarge.copyWith(
              color: t.onSurfaceColor)),
          Text(destination.country,
            style: AppTypography.headlineMedium.copyWith(
              color: t.onSurfaceColor.withAlpha(160))),
          const SizedBox(height: AppSpacing.sm),
          Text(destination.tagline,
            style: AppTypography.bodyLarge.copyWith(
              color: t.onSurfaceColor.withAlpha(180))),
          const SizedBox(height: AppSpacing.md),
          Text(destination.formattedPrice,
            style: AppTypography.headlineMedium.copyWith(
              color: t.brandPrimary, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.xl),
          // L10 placeholder — real CTA wired in Lesson 11
          NomadButton(
            label: 'Book This Destination',
            icon: Icons.flight_takeoff,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: AppSpacing.md),
          _ScreenNote(
            'DestinationDetailScreen · discovery/screens/\n'
            'Receives DiscoveryDestination via Navigator arguments.\n'
            'Hero animation added in Lesson 49.'),
        ],
      ),
    );
  }
}

class _HeroPainter extends CustomPainter {
  const _HeroPainter({required this.top,required this.bottom,required this.iata});
  final Color top,bottom;
  final String iata;

  @override
  void paint(Canvas c,Size s){
    final r=Offset.zero&s;
    c.drawRect(r,Paint()..shader=LinearGradient(
      begin:Alignment.topLeft,end:Alignment.bottomRight,
      colors:[top,bottom]).createShader(r));
    final tp=TextPainter(
      text:TextSpan(text:iata,style:TextStyle(
        color:Colors.white.withAlpha(40),fontSize:96,
        fontWeight:FontWeight.w900,fontFamily:'monospace')),
      textDirection:TextDirection.ltr)..layout();
    tp.paint(c,Offset(s.width-tp.width-16,s.height/2-tp.height/2));
  }

  @override bool shouldRepaint(_HeroPainter o)=>
      o.top!=top||o.bottom!=bottom;
}

class _ScreenNote extends StatelessWidget {
  const _ScreenNote(this.text);
  final String text;
  @override
  Widget build(BuildContext context){
    final t=Theme.of(context).extension<NomadThemeExtension>()!;
    return Container(
      padding:const EdgeInsets.all(AppSpacing.sm),
      decoration:BoxDecoration(
        color:t.brandPrimary.withAlpha(12),
        borderRadius:BorderRadius.circular(AppSpacing.radiusSm),
        border:Border.all(color:t.brandPrimary.withAlpha(60))),
      child:Text(text,style:AppTypography.monoSmall.copyWith(
        color:t.brandPrimary.withAlpha(200))));
  }
}
