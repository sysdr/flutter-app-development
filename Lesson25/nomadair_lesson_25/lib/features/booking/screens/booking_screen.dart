import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:provider/provider.dart';
import '../../../core/transitions/hero_tags.dart';
import '../../../router/navigator_routes.dart';
import '../../search/models/flight_result.dart';
import '../models/booking_error.dart';
import '../providers/booking_notifier.dart';

// Full booking confirmation screen — replaces BookingStubScreen.
//
// States:
//   BookingIdle    → shows flight summary + CTA
//   BookingLoading → spinner, CTA disabled
//   BookingConfirmed → booking reference + success UI
//   BookingFailed  → error-specific UI with contextual action
//     FlightUnavailableError → "Back to search" button
//     PriceChangedError      → new price + accept/decline
//     NetworkError           → retry button
final class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key, required this.flight});
  final FlightResult flight;

  @override Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingNotifier(
          context.read<FlightRepositoryProvider>().repo),
      child: _BookingBody(flight: flight));
  }
}

// FlightRepositoryProvider injected in main.dart so BookingNotifier
// can access the repo without coupling to MockConfig directly.
final class FlightRepositoryProvider {
  const FlightRepositoryProvider(this.repo);
  final dynamic repo; // FlightRepository
}

final class _BookingBody extends StatelessWidget {
  const _BookingBody({required this.flight});
  final FlightResult flight;

  @override Widget build(BuildContext context) {
    final notifier = context.watch<BookingNotifier>();
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Booking'),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop())),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (notifier.state) {
          BookingIdle()      => _IdleView(flight: flight, t: t),
          BookingLoading()   => const _LoadingView(),
          BookingConfirmed() => _ConfirmedView(
              state: notifier.state as BookingConfirmed, t: t),
          BookingFailed()    => _ErrorView(
              flight: flight,
              state: notifier.state as BookingFailed,
              t: t),
        }),
    );
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView({required this.flight, required this.t});
  final FlightResult flight;
  final NomadThemeExtension t;

  @override Widget build(BuildContext context) {
    final notifier = context.read<BookingNotifier>();
    return ListView(
      key: const ValueKey('idle'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _SummaryCard(flight: flight, t: t),
        const SizedBox(height: AppSpacing.xl),
        Text('Total fare',
          style: AppTypography.labelLarge.copyWith(
              color: t.onSurfaceColor.withAlpha(150))),
        const SizedBox(height: AppSpacing.xs),
        Hero(
          tag: HeroTags.flightPrice(flight.id),
          child: Material(
            color: Colors.transparent,
            child: Text(flight.formattedPrice,
              style: AppTypography.displayLarge.copyWith(
                color: t.brandPrimary, fontWeight: FontWeight.w800)))),
        const SizedBox(height: AppSpacing.xl),
        NomadButton(
          label: 'Confirm & Book',
          icon:  Icons.check_circle_outline,
          onPressed: () => notifier.confirmBooking(flight)),
      ]);
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override Widget build(BuildContext context) =>
      const Center(key: ValueKey('loading'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: AppSpacing.lg),
              Text('Verifying availability…'),
            ]));
}

class _ConfirmedView extends StatelessWidget {
  const _ConfirmedView({required this.state, required this.t});
  final BookingConfirmed state;
  final NomadThemeExtension t;
  @override Widget build(BuildContext context) =>
      Center(key: const ValueKey('confirmed'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 72, color: t.successColor),
              const SizedBox(height: AppSpacing.lg),
              Text('Booking Confirmed!',
                style: AppTypography.headlineLarge.copyWith(
                  color: t.successColor)),
              const SizedBox(height: AppSpacing.sm),
              Text('Ref: ${state.bookingRef}',
                style: AppTypography.headlineMedium.copyWith(
                  color: t.onSurfaceColor,
                  fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.xl),
              NomadButton(
                label: 'View Trips',
                icon:  Icons.luggage,
                onPressed: () => context.go(NavigatorRoutes.trips)),
            ])));
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.flight, required this.state, required this.t});
  final FlightResult   flight;
  final BookingFailed  state;
  final NomadThemeExtension t;

  @override Widget build(BuildContext context) {
    final notifier = context.read<BookingNotifier>();
    return Center(key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ..._errorContent(context, notifier),
          ])));
  }

  List<Widget> _errorContent(
      BuildContext ctx, BookingNotifier notifier) {
    return switch (state.error) {
      FlightUnavailableError() => [
        Icon(Icons.flight_takeoff, size: 72, color: t.errorColor),
        const SizedBox(height: AppSpacing.lg),
        Text('Flight No Longer Available',
          style: AppTypography.headlineMedium.copyWith(
            color: t.errorColor)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'This offer has expired. Please return to search results '
          'and select another flight.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: t.onSurfaceColor.withAlpha(160))),
        const SizedBox(height: AppSpacing.xl),
        NomadButton(
          label:     'Back to Search Results',
          variant:   const OutlinedVariant(),
          icon:      Icons.search,
          onPressed: () => ctx.go(NavigatorRoutes.searchResults)),
      ],
      PriceChangedError(:final newPrice,
                         :final originalPrice,
                         :final formattedDelta,
                         :final priceIncreased) => [
        Icon(Icons.price_change, size: 72,
          color: priceIncreased ? t.errorColor : t.successColor),
        const SizedBox(height: AppSpacing.lg),
        Text('Price Has Changed',
          style: AppTypography.headlineMedium.copyWith(
            color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          priceIncreased
            ? 'The price increased by $formattedDelta.'
            : 'Good news — the price dropped by $formattedDelta!',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: t.onSurfaceColor.withAlpha(160))),
        const SizedBox(height: AppSpacing.sm),
        Text('New price: ₹${newPrice.toStringAsFixed(0)}',
          style: AppTypography.headlineLarge.copyWith(
            color: t.brandPrimary, fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.xl),
        NomadButton(
          label:     'Accept New Price',
          icon:      Icons.check,
          onPressed: () => notifier.confirmBooking(
              FlightResult(
                id: flight.id,
                airline: flight.airline,
                airlineCode: flight.airlineCode,
                flightNumber: flight.flightNumber,
                baggageAllowance: flight.baggageAllowance,
                origin: flight.origin,
                destination: flight.destination,
                departureTime: flight.departureTime,
                arrivalTime: flight.arrivalTime,
                durationMinutes: flight.durationMinutes,
                stops: flight.stops,
                cabinClass: flight.cabinClass,
                priceInr: newPrice,
                seatsLeft: flight.seatsLeft,
                isRefundable: flight.isRefundable,
              ))),
        const SizedBox(height: AppSpacing.sm),
        NomadButton(
          label:     'Decline',
          variant:   const OutlinedVariant(),
          onPressed: () => ctx.pop()),
      ],
      NetworkError(:final message) => [
        Icon(Icons.wifi_off, size: 72,
          color: t.onSurfaceColor.withAlpha(100)),
        const SizedBox(height: AppSpacing.lg),
        Text('Connection Problem',
          style: AppTypography.headlineMedium.copyWith(
            color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.sm),
        Text(message,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: t.onSurfaceColor.withAlpha(160))),
        const SizedBox(height: AppSpacing.xl),
        NomadButton(
          label:     'Retry',
          icon:      Icons.refresh,
          onPressed: () => notifier.retry(flight)),
      ],
    };
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.flight, required this.t});
  final FlightResult flight;
  final NomadThemeExtension t;
  @override Widget build(BuildContext context) =>
      NomadCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(flight.airline,
              style: AppTypography.headlineMedium.copyWith(
                color: t.onSurfaceColor)),
            const SizedBox(height: AppSpacing.xs),
            Row(children: [
              Text(flight.origin,
                style: AppTypography.headlineLarge.copyWith(
                  color: t.brandPrimary)),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md),
                child: Icon(Icons.arrow_forward,
                  color: t.onSurfaceColor.withAlpha(120))),
              Text(flight.destination,
                style: AppTypography.headlineLarge.copyWith(
                  color: t.brandPrimary)),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Text('${flight.formattedDuration}  ·  ${flight.stopsLabel}',
              style: AppTypography.bodyMedium.copyWith(
                color: t.onSurfaceColor.withAlpha(160))),
          ]));
}
