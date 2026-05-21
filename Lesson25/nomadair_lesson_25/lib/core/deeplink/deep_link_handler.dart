import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../features/search/models/selected_city.dart';
import '../../../features/search/providers/flight_search_notifier.dart';
import '../../../features/search/providers/search_criteria_notifier.dart';
import '../../../router/navigator_routes.dart';
import '../../cache/cache_service.dart';
import '../../cache/cached_flight_repository.dart';
import '../../config/mock_config.dart';
import 'deep_link_intent.dart';
import 'deep_link_resolver.dart';

// Routes a DeepLinkIntent to the correct screen.
//
// SearchIntent:  check cache → fresh → navigate to results immediately.
//                             stale → pre-fill form and go to search.
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
      dynamic criteria, BuildContext context) async {
    // Check cache first
    final cache = MockConfig.cachedFlightRepository;
    if (cache is CachedFlightRepository) {
      final key     = CachedFlightRepository.cacheKey(criteria);
      final cacheService = context.read<CacheService?>() ??
          MockCacheProxy(MockConfig.cachedFlightRepository);
      final entry = await (cache as dynamic).cacheServiceForTest
          ?.get(key);
      if (entry != null && !(entry as dynamic).isExpired) {
        // Cache hit: pre-load notifier and jump to results
        if (!context.mounted) return;
        final notifier = context.read<SearchCriteriaNotifier>();
        notifier.setOrigin(criteria.origin as SelectedCity);
        notifier.setDestination(criteria.destination as SelectedCity);
        notifier.setDepartureDate(criteria.departureDate);
        context.go(NavigatorRoutes.searchResults);
        return;
      }
    }
    // Cache miss or not cached: pre-fill and let user tap Search
    _handlePreFill(
      (criteria.origin as SelectedCity?)?.iata,
      (criteria.destination as SelectedCity?)?.iata,
      criteria.departureDate as DateTime?,
      context,
    );
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

// Minimal proxy to avoid import cycle in handler — only used in tests.
class MockCacheProxy {
  MockCacheProxy(dynamic _);
}
