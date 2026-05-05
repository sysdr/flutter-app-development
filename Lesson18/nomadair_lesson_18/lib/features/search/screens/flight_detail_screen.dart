import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../router/navigator_routes.dart';
import '../models/flight_result.dart';

/// Lesson 18 — Full-screen flight detail screen.
///
/// Receives a [FlightResult] via GoRouter extra:
///   context.push(NavigatorRoutes.flightDetail, extra: flight)
///
/// Displays: airline · times · route · duration · stops · cabin ·
///           baggage · refundable badge · price · CTA
///
/// "Continue to Booking" → BookingStubScreen (Module 5 placeholder)
final class FlightDetailScreen extends StatelessWidget {
  const FlightDetailScreen({super.key, required this.flight});
  final FlightResult flight;
  static final _tf = DateFormat('HH:mm');
  static final _df = DateFormat('EEE, dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${flight.airline}  ·  ${flight.flightNumber}',
          style: AppTypography.headlineSmall),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop())),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // ── Hero: time + route ──────────────────────────────────
          Card(child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _TBlock(time: _tf.format(flight.departureTime),
                    iata: flight.origin, t: t),
                  Expanded(child: Column(children: [
                    Text(flight.formattedDuration,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: t.onSurfaceColor.withAlpha(150))),
                    const SizedBox(height: 6),
                    Row(children: [
                      Expanded(child: Divider(height: 1,
                        color: t.onSurfaceColor.withAlpha(80))),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ExcludeSemantics(child: Icon(
                          Icons.flight, size: 18, color: t.brandPrimary))),
                      Expanded(child: Divider(height: 1,
                        color: t.onSurfaceColor.withAlpha(80))),
                    ]),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: flight.stops == 0
                          ? t.successColor.withAlpha(14)
                          : t.warningColor.withAlpha(14),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull),
                        border: Border.all(color: flight.stops == 0
                          ? t.successColor.withAlpha(80)
                          : t.warningColor.withAlpha(80))),
                      child: Text(flight.stopsLabel,
                        style: AppTypography.labelMedium.copyWith(
                          color: flight.stops == 0
                            ? t.successColor : t.warningColor))),
                  ])),
                  _TBlock(time: _tf.format(flight.arrivalTime),
                    iata: flight.destination, t: t, alignEnd: true),
                ]),
              const SizedBox(height: AppSpacing.sm),
              Text(_df.format(flight.departureTime),
                style: AppTypography.bodySmall.copyWith(
                  color: t.onSurfaceColor.withAlpha(140))),
            ]))),
          const SizedBox(height: AppSpacing.md),
          // ── Fare details ────────────────────────────────────────
          Card(child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(children: [
              _Row(icon: Icons.airline_seat_recline_normal_outlined,
                label: 'Cabin class',
                value: flight.cabinClass.label, t: t),
              _Divider(t),
              _Row(icon: Icons.luggage_outlined,
                label: 'Baggage',
                value: flight.baggageAllowance, t: t),
              _Divider(t),
              _Row(icon: Icons.event_seat_outlined,
                label: 'Seats available',
                value: flight.seatsLeft <= 5
                  ? 'Only ${flight.seatsLeft} left!'
                  : '${flight.seatsLeft} available',
                valueColor: flight.seatsLeft <= 5
                  ? t.warningColor : null, t: t),
              if (flight.isRefundable) ...[
                _Divider(t),
                _Row(icon: Icons.check_circle_outline,
                  label: 'Refund policy',
                  value: 'Fully refundable',
                  valueColor: t.successColor, t: t),
              ],
            ]))),
          const SizedBox(height: AppSpacing.md),
          // ── Price + CTA ─────────────────────────────────────────
          Card(child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total fare',
                    style: AppTypography.bodyLarge.copyWith(
                      color: t.onSurfaceColor.withAlpha(160))),
                  Text(flight.formattedPrice,
                    style: AppTypography.displayLarge.copyWith(
                      color: t.brandPrimary,
                      fontWeight: FontWeight.w700)),
                ]),
              const SizedBox(height: AppSpacing.xs),
              Text('per person, taxes included',
                style: AppTypography.bodySmall.copyWith(
                  color: t.onSurfaceColor.withAlpha(110))),
            ]))),
          const SizedBox(height: AppSpacing.xl),
          // ── Action buttons ──────────────────────────────────────
          NomadButton(
            label: 'Continue to Booking',
            icon: Icons.arrow_forward,
            semanticLabel:
              'Continue booking ${flight.airline} ${flight.flightNumber}',
            onPressed: () =>
              context.push(NavigatorRoutes.bookingStub, extra: flight)),
          const SizedBox(height: AppSpacing.sm),
          NomadButton(
            label: 'Back to Results',
            variant: const OutlinedVariant(),
            onPressed: () => context.pop()),
          const SizedBox(height: AppSpacing.xl),
        ]));
  }
}

class _TBlock extends StatelessWidget {
  const _TBlock({required this.time, required this.iata,
    required this.t, this.alignEnd = false});
  final String time, iata;
  final NomadThemeExtension t;
  final bool alignEnd;
  @override Widget build(BuildContext context) => SizedBox(
    width: 72,
    child: Column(
      crossAxisAlignment:
        alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, children: [
      Text(time, style: AppTypography.displayLarge.copyWith(
        color: t.onSurfaceColor, fontWeight: FontWeight.w700,
        fontSize: 28)),
      Text(iata, style: AppTypography.monoMedium.copyWith(
        color: t.brandPrimary, fontWeight: FontWeight.w700)),
    ]));
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label,
    required this.value, required this.t, this.valueColor});
  final IconData icon; final String label, value;
  final NomadThemeExtension t; final Color? valueColor;
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    child: Row(children: [
      ExcludeSemantics(child: Icon(icon, size: 18,
        color: t.onSurfaceColor.withAlpha(130))),
      const SizedBox(width: AppSpacing.md),
      Expanded(child: Text(label,
        style: AppTypography.bodyMedium.copyWith(
          color: t.onSurfaceColor.withAlpha(160)))),
      Text(value, style: AppTypography.bodyMedium.copyWith(
        color: valueColor ?? t.onSurfaceColor,
        fontWeight: FontWeight.w600)),
    ]));
}

Widget _Divider(NomadThemeExtension t) =>
    Divider(height: 1, color: t.dividerColor);
