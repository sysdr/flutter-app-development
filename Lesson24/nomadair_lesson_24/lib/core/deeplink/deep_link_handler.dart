import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../features/search/models/search_criteria.dart';
import '../../../features/search/providers/flight_search_notifier.dart';
import '../../../features/search/providers/search_criteria_notifier.dart';
import '../../../router/navigator_routes.dart';
import 'deep_link_intent.dart';
import 'deep_link_resolver.dart';

// Routes a DeepLinkIntent to the correct screen.
//
// SearchIntent:  sync criteria → run search (uses CachedFlightRepository
//                in FlightSearchNotifier — cache hit skips mock HTTP).
// PreFillIntent: navigate to search tab with pre-filled fields.
// InvalidIntent: show error SnackBar on whichever tab is visible.
final class DeepLinkHandler {
  const DeepLinkHandler();

  static final _resolver = const DeepLinkResolver();

  Future<void> handle(Uri uri, BuildContext context) async {
    final intent = _resolver.resolve(uri);
    await _dispatch(intent, context);
  }

  Future<void> _dispatch(
      DeepLinkIntent intent, BuildContext context) async {
    switch (intent) {
      case SearchIntent(:final criteria):
        await _handleSearch(criteria, context);
      case PreFillIntent(:final originIata, :final destinationIata,
                          :final date):
        _handlePreFill(originIata, destinationIata, date, context);
      case InvalidIntent(:final reason):
        _showError(reason, context);
    }
  }

  Future<void> _handleSearch(
      SearchCriteria criteria, BuildContext context) async {
    if (!context.mounted) return;
    final criteriaNotifier = context.read<SearchCriteriaNotifier>();
    criteriaNotifier.setOrigin(criteria.origin);
    criteriaNotifier.setDestination(criteria.destination);
    criteriaNotifier.setDepartureDate(criteria.departureDate);

    final flightNotifier = context.read<FlightSearchNotifier>();
    await flightNotifier.search(criteria);
    if (!context.mounted) return;

    final st = flightNotifier.state;
    if (st is FlightSearchLoaded) {
      context.go(NavigatorRoutes.searchResults);
    } else if (st is FlightSearchError) {
      _showError(st.message, context);
    }
  }

  void _handlePreFill(
    String? originIata,
    String? destinationIata,
    DateTime? date,
    BuildContext context,
  ) {
    if (!context.mounted) return;
    context.go(
      NavigatorRoutes.search,
      extra: {
        'from': originIata,
        'to':   destinationIata,
        'date': date?.toIso8601String().substring(0, 10),
      },
    );
  }

  void _showError(String reason, BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deep link error: $reason'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
