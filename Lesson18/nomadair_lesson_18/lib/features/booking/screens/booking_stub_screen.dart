import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../features/search/models/flight_result.dart';

/// Lesson 18 — BookingStubScreen.
///
/// Placeholder for the full booking flow (Lesson 40+).
/// Accessible from FlightDetailScreen via:
///   context.push(NavigatorRoutes.bookingStub, extra: flight)
///
/// Shows selected flight info so the student can verify the
/// GoRouter extra passed correctly through two levels of navigation.
final class BookingStubScreen extends StatelessWidget {
  const BookingStubScreen({super.key, this.flight});
  final FlightResult? flight;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop())),
      body: Center(child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child: Icon(Icons.construction_outlined,
              size: 72, color: t.onSurfaceColor.withAlpha(80))),
            const SizedBox(height: AppSpacing.lg),
            Text('Booking Flow',
              style: AppTypography.headlineLarge.copyWith(
                color: t.onSurfaceColor)),
            const SizedBox(height: AppSpacing.xs),
            Text('Coming in Module 5',
              style: AppTypography.bodyLarge.copyWith(
                color: t.onSurfaceColor.withAlpha(150))),
            if (flight != null) ...[
              const SizedBox(height: AppSpacing.xl),
              Card(child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected flight',
                      style: AppTypography.labelMedium.copyWith(
                        color: t.onSurfaceColor.withAlpha(150))),
                    const SizedBox(height: AppSpacing.sm),
                    Text('${flight!.airline}  ·  ${flight!.flightNumber}',
                      style: AppTypography.headlineSmall.copyWith(
                        color: t.onSurfaceColor)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${flight!.origin} → ${flight!.destination}  '
                      '·  ${flight!.stopsLabel}  '
                      '·  ${flight!.formattedDuration}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: t.onSurfaceColor.withAlpha(160))),
                    const SizedBox(height: AppSpacing.sm),
                    Text(flight!.formattedPrice,
                      style: AppTypography.headlineMedium.copyWith(
                        color: t.brandPrimary,
                        fontWeight: FontWeight.w700)),
                  ]))),
            ],
            const SizedBox(height: AppSpacing.xl),
            SizedBox(width: 200, child: NomadButton(
              label: 'Back',
              variant: const OutlinedVariant(),
              onPressed: () => context.pop())),
          ]))));
  }
}
