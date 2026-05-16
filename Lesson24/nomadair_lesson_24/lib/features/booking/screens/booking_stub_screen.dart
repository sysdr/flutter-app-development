import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../router/navigator_routes.dart';
import '../../search/models/flight_result.dart';

final class BookingStubScreen extends StatelessWidget {
  const BookingStubScreen({super.key, this.flight});
  final FlightResult? flight;

  @override Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop())),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(child: Icon(
                Icons.rocket_launch_outlined,
                size: 80,
                color: t.brandPrimary.withAlpha(160))),
              const SizedBox(height: AppSpacing.lg),
              Text('Module 5: Booking Flow',
                style: AppTypography.headlineLarge.copyWith(
                  color: t.onSurfaceColor)),
              const SizedBox(height: AppSpacing.md),
              Text(
                'The full booking flow is built in Module 5 (Lessons 43–54).'
                '\nThis stub confirms navigation from FlightDetailScreen works.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: t.onSurfaceColor.withAlpha(160))),
              if (flight != null) ...[
                const SizedBox(height: AppSpacing.xl),
                NomadCard(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(flight!.airline,
                      style: AppTypography.headlineSmall.copyWith(
                        color: t.onSurfaceColor)),
                    Text(
                      '${flight!.origin} → ${flight!.destination}  '
                      '· ${flight!.formattedPrice}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: t.onSurfaceColor.withAlpha(160))),
                  ])),
              ],
              const SizedBox(height: AppSpacing.xl),
              SizedBox(width: 220,
                child: NomadButton(
                  label: 'Back to Results',
                  variant: const OutlinedVariant(),
                  icon: Icons.arrow_back,
                  onPressed: () => context.go(NavigatorRoutes.search))),
            ]))));
  }
}
