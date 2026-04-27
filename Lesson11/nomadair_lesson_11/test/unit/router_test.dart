import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_11/router/navigator_routes.dart';
import 'package:nomadair_lesson_11/router/app_router.dart';
import 'package:nomadair_lesson_11/features/discovery/models/destination_model.dart';
import 'package:nomadair_lesson_11/features/search/models/search_criteria.dart';

void main() {
  group('NavigatorRoutes constants', () {
    test('all 11 routes defined', () =>
        expect(NavigatorRoutes.all.length, equals(11)));

    test('all routes start with /', () {
      for (final r in NavigatorRoutes.all) {
        expect(r.startsWith('/'), isTrue, reason: '$r must start with /');
      }
    });

    test('routes are unique', () {
      expect(NavigatorRoutes.all.toSet().length,
          equals(NavigatorRoutes.all.length));
    });

    test('shell tabs have distinct first path segments', () {
      expect(NavigatorRoutes.discovery, startsWith('/discovery'));
      expect(NavigatorRoutes.search,    startsWith('/search'));
      expect(NavigatorRoutes.trips,     startsWith('/trips'));
    });

    test('booking routes share /booking prefix', () {
      expect(NavigatorRoutes.seatMap,      contains('/booking'));
      expect(NavigatorRoutes.passengerForm, contains('/booking'));
      expect(NavigatorRoutes.payment,       contains('/booking'));
      expect(NavigatorRoutes.confirmation,  contains('/booking'));
    });
  });

  group('AppRouter', () {
    test('isLoggedIn starts false', () =>
        expect(AppRouter.isLoggedIn.value, isFalse));

    test('router instance is non-null', () =>
        expect(AppRouter.router, isNotNull));

    test('toggle isLoggedIn', () {
      AppRouter.isLoggedIn.value = true;
      expect(AppRouter.isLoggedIn.value, isTrue);
      AppRouter.isLoggedIn.value = false; // reset
    });
  });

  group('DiscoveryDestination', () {
    test('samples not empty', () =>
        expect(DiscoveryDestination.samples.isNotEmpty, isTrue));

    test('trending rank set on first sample', () =>
        expect(DiscoveryDestination.samples.first.isTrending, isTrue));
  });

  group('SearchCriteria', () {
    test('isValid false when empty', () =>
        expect(const SearchCriteria().isValid, isFalse));

    test('isValid true when origin + dest + date', () {
      final c = SearchCriteria(
        origin: 'BOM', destination: 'DXB',
        departureDate: DateTime.now().add(const Duration(days: 7)));
      expect(c.isValid, isTrue);
    });
  });
}
