import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../router/navigator_routes.dart';
import '../../../core/transitions/hero_tags.dart';
import '../models/flight_result.dart';

final class FlightDetailScreen extends StatelessWidget {
  const FlightDetailScreen({super.key, required this.flight});
  final FlightResult flight;

  @override Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${flight.airline} ${flight.flightNumber}'),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop())),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _InfoRow(icon: Icons.flight_takeoff, label: 'From',
            value: flight.origin),
          _InfoRow(icon: Icons.flight_land,    label: 'To',
            value: flight.destination),
          _InfoRow(icon: Icons.schedule,       label: 'Duration',
            value: flight.formattedDuration),
          _InfoRow(icon: Icons.connecting_airports, label: 'Stops',
            value: flight.stopsLabel),
          _InfoRow(icon: Icons.airline_seat_recline_normal,
            label: 'Class',   value: flight.cabinClass.label),
          _InfoRow(icon: Icons.luggage, label: 'Baggage',
            value: flight.baggageAllowance),
          _InfoRow(
            icon: flight.isRefundable
                ? Icons.check_circle_outline
                : Icons.cancel_outlined,
            label: 'Refundable',
            value: flight.isRefundable ? 'Yes' : 'No',
            valueColor: flight.isRefundable
                ? t.successColor : t.errorColor),
          Divider(color: t.dividerColor,
            height: AppSpacing.xl * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Fare',
                style: AppTypography.headlineSmall.copyWith(
                  color: t.onSurfaceColor)),
              // Hero matches FlightResultCard price Hero
              Hero(
                tag: HeroTags.flightPrice(flight.id),
                child: Material(
                  color: Colors.transparent,
                  child: Text(flight.formattedPrice,
                    style: AppTypography.headlineLarge.copyWith(
                      color: t.brandPrimary,
                      fontWeight: FontWeight.w800)))),
            ]),
          const SizedBox(height: AppSpacing.xl),
          NomadButton(
            label: 'Continue to Booking',
            icon: Icons.arrow_forward,
            onPressed: () => context.push(
              NavigatorRoutes.bookingStub, extra: flight)),
        ]));
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });
  final IconData icon;
  final String label, value;
  final Color? valueColor;

  @override Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(children: [
        Icon(icon, size: 20, color: t.onSurfaceColor.withAlpha(140)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(label,
          style: AppTypography.bodyMedium.copyWith(
            color: t.onSurfaceColor.withAlpha(140)))),
        Text(value,
          style: AppTypography.bodyMedium.copyWith(
            color: valueColor ?? t.onSurfaceColor,
            fontWeight: FontWeight.w600)),
      ]));
  }
}
