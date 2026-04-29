import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

/// Full-screen destination card for [PageView.builder] feed mode.
///
/// Fills the entire viewport. Destination metadata overlays the bottom
/// of the gradient hero with a dark scrim for readability.
///
/// Used when the user switches to "Full Screen" feed mode.
final class DiscoveryCardFull extends StatelessWidget {
  const DiscoveryCardFull({
    super.key,
    required this.destination,
    this.onBook,
  });

  final dynamic destination;
  final VoidCallback?         onBook;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Semantics(
      label: '${destination.city}, ${destination.country}. '
             '${destination.tagline}. ${destination.formattedPrice}.',
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Hero gradient (fills entire card)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              t.imageOverlayColor, BlendMode.srcATop),
            child: CustomPaint(
              painter: _FullHeroPainter(
                top:    Color(destination.skyColorTop),
                bottom: Color(destination.skyColorBottom),
                iata:   destination.iataCode,
              ),
            ),
          ),
          // Bottom scrim
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end:   Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(200),
                  ],
                ),
              ),
            ),
          ),
          // Metadata overlay
          Positioned(
            left:   AppSpacing.lg,
            right:  AppSpacing.lg,
            bottom: AppSpacing.xl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (destination.isTrending)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical:   AppSpacing.xs,
                    ),
                    margin: const EdgeInsets.only(
                      bottom: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: t.brandAccent.withAlpha(220),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusFull),
                    ),
                    child: Text(
                      '#${destination.trendingRank} Trending',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                Text(
                  destination.city,
                  style: AppTypography.displayLarge.copyWith(
                    color: AppColors.white,
                    shadows: [
                      const Shadow(
                        blurRadius: 8,
                        color: Colors.black54),
                    ],
                  ),
                ),
                Text(
                  destination.country,
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.white.withAlpha(200)),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  destination.tagline,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white.withAlpha(180)),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        destination.formattedPrice,
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (onBook != null)
                      Semantics(
                        label:
                            'Book ${destination.city}. '
                            '${destination.formattedPrice}',
                        button: true,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                AppColors.white.withAlpha(230),
                            foregroundColor: AppColors.grey900,
                            minimumSize: const Size(
                              120, AppSpacing.minTouchTarget),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd)),
                          ),
                          onPressed: onBook,
                          child: const Text('Book Now'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Swipe hint
          Positioned(
            top:   AppSpacing.md,
            right: AppSpacing.md,
            child: ExcludeSemantics(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical:   AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(100),
                  borderRadius: BorderRadius.circular(
                    AppSpacing.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.swipe_vertical,
                      color: Colors.white, size: 14),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Swipe',
                      style: AppTypography.monoSmall.copyWith(
                        color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _FullHeroPainter extends CustomPainter {
  const _FullHeroPainter({
    required this.top,
    required this.bottom,
    required this.iata,
  });
  final Color  top, bottom;
  final String iata;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()
      ..shader = LinearGradient(
        begin:  Alignment.topLeft,
        end:    Alignment.bottomRight,
        colors: [top, bottom],
      ).createShader(rect));
    final tp = TextPainter(
      text: TextSpan(text: iata, style: TextStyle(
        color:      Colors.white.withAlpha(30),
        fontSize:   140,
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace',
      )),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(
      size.width  / 2 - tp.width  / 2,
      size.height / 2 - tp.height / 2,
    ));
  }

  @override
  bool shouldRepaint(_FullHeroPainter old) =>
      old.top != top || old.bottom != bottom;
}
