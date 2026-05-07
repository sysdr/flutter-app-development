import 'package:flutter/material.dart' show ThemeMode;
import '../../features/search/models/recent_search.dart';

abstract interface class LocalStorageService {
  Future<void>      saveThemeMode(ThemeMode mode);
  Future<ThemeMode> loadThemeMode();
  Future<void>      saveCurrencyCode(String code);
  Future<String>    loadCurrencyCode();
  Future<void>               addRecentSearch(RecentSearch search);
  Future<List<RecentSearch>> loadRecentSearches();
  Future<void>               clearRecentSearches();
  Future<void>               dispose();
}
