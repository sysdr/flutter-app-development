import 'package:flutter/material.dart' show ThemeMode;
import '../../features/search/models/recent_search.dart';
import 'local_storage_service.dart';
import 'storage_keys.dart';

final class MockStorageService implements LocalStorageService {
  ThemeMode _themeMode = ThemeMode.system;
  String    _currency  = StorageKeys.defaultCurrency;
  final List<RecentSearch> _searches = [];

  @override Future<void>      saveThemeMode(ThemeMode m) async => _themeMode = m;
  @override Future<ThemeMode> loadThemeMode()              async => _themeMode;
  @override Future<void>      saveCurrencyCode(String c)   async => _currency = c;
  @override Future<String>    loadCurrencyCode()           async => _currency;

  @override
  Future<void> addRecentSearch(RecentSearch search) async {
    _searches.removeWhere((s) =>
        s.originIata      == search.originIata &&
        s.destinationIata == search.destinationIata);
    _searches.insert(0, search);
    while (_searches.length > StorageKeys.maxRecentSearches) {
      _searches.removeLast();
    }
  }

  @override
  Future<List<RecentSearch>> loadRecentSearches() async =>
      List.unmodifiable(_searches);

  @override Future<void> clearRecentSearches() async => _searches.clear();
  @override Future<void> dispose()              async {}
}
