import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_24/core/services/mock_storage_service.dart';
import 'package:nomadair_lesson_24/core/services/storage_keys.dart';
import 'package:nomadair_lesson_24/features/search/models/recent_search.dart';

RecentSearch _rs({
  String from = 'BOM', String fromName = 'Mumbai',
  String to   = 'DXB', String toName   = 'Dubai',
  String cabin = 'Economy', int pax = 1,
}) => RecentSearch(
  originIata: from, originName: fromName,
  destinationIata: to, destinationName: toName,
  searchedAt: DateTime(2025, 5, 1),
  cabinClassLabel: cabin, passengerCount: pax,
);

void main() {
  group('MockStorageService', () {
    late MockStorageService svc;
    setUp(() => svc = MockStorageService());

    group('themeMode', () {
      test('default is ThemeMode.system', () async {
        expect(await svc.loadThemeMode(), ThemeMode.system);
      });
      test('save and load light', () async {
        await svc.saveThemeMode(ThemeMode.light);
        expect(await svc.loadThemeMode(), ThemeMode.light);
      });
      test('save and load dark', () async {
        await svc.saveThemeMode(ThemeMode.dark);
        expect(await svc.loadThemeMode(), ThemeMode.dark);
      });
      test('overwrites previous value', () async {
        await svc.saveThemeMode(ThemeMode.light);
        await svc.saveThemeMode(ThemeMode.system);
        expect(await svc.loadThemeMode(), ThemeMode.system);
      });
    });

    group('currencyCode', () {
      test('default is INR', () async {
        expect(await svc.loadCurrencyCode(), 'INR');
      });
      test('save and load USD', () async {
        await svc.saveCurrencyCode('USD');
        expect(await svc.loadCurrencyCode(), 'USD');
      });
      test('save and load AED', () async {
        await svc.saveCurrencyCode('AED');
        expect(await svc.loadCurrencyCode(), 'AED');
      });
    });

    group('recentSearches', () {
      test('empty initially', () async {
        expect(await svc.loadRecentSearches(), isEmpty);
      });
      test('add one search', () async {
        await svc.addRecentSearch(_rs());
        expect(await svc.loadRecentSearches(), hasLength(1));
      });
      test('newest is first', () async {
        await svc.addRecentSearch(_rs(from: 'BOM', to: 'DXB'));
        await svc.addRecentSearch(_rs(from: 'DEL', to: 'LHR'));
        final list = await svc.loadRecentSearches();
        expect(list.first.originIata, 'DEL');
      });
      test('duplicate route not appended', () async {
        await svc.addRecentSearch(_rs(from: 'BOM', to: 'DXB'));
        await svc.addRecentSearch(_rs(from: 'BOM', to: 'DXB'));
        expect(await svc.loadRecentSearches(), hasLength(1));
      });
      test('duplicate moves to front', () async {
        await svc.addRecentSearch(_rs(from: 'BOM', to: 'DXB'));
        await svc.addRecentSearch(_rs(from: 'DEL', to: 'SIN'));
        await svc.addRecentSearch(_rs(from: 'BOM', to: 'DXB'));
        final list = await svc.loadRecentSearches();
        expect(list.first.originIata, 'BOM');
        expect(list, hasLength(2));
      });
      test('cap at ${StorageKeys.maxRecentSearches}', () async {
        for (final r in [('BOM','DXB'),('DEL','LHR'),('BLR','SIN'),
                          ('HYD','NRT'),('MAA','CDG'),('CCU','LGW')]) {
          await svc.addRecentSearch(_rs(from: r.$1, to: r.$2));
        }
        expect((await svc.loadRecentSearches()).length,
            StorageKeys.maxRecentSearches);
      });
      test('oldest dropped when cap exceeded', () async {
        for (final r in [('BOM','DXB'),('DEL','LHR'),('BLR','SIN'),
                          ('HYD','NRT'),('MAA','CDG'),('CCU','LGW')]) {
          await svc.addRecentSearch(_rs(from: r.$1, to: r.$2));
        }
        final iatas = (await svc.loadRecentSearches())
            .map((s) => s.originIata).toList();
        expect(iatas, isNot(contains('BOM')));
      });
      test('clear removes all', () async {
        await svc.addRecentSearch(_rs());
        await svc.clearRecentSearches();
        expect(await svc.loadRecentSearches(), isEmpty);
      });
      test('clear then add starts fresh', () async {
        await svc.addRecentSearch(_rs(from: 'BOM', to: 'DXB'));
        await svc.clearRecentSearches();
        await svc.addRecentSearch(_rs(from: 'DEL', to: 'LHR'));
        final list = await svc.loadRecentSearches();
        expect(list, hasLength(1));
        expect(list.first.originIata, 'DEL');
      });
      test('routeLabel arrow present', () {
        expect(_rs().routeLabel, contains('→'));
      });
      test('detailLabel includes count and cabin', () {
        final r = _rs(cabin: 'Business', pax: 2);
        expect(r.detailLabel, contains('2 pax'));
        expect(r.detailLabel, contains('Business'));
      });
    });
  });
}
