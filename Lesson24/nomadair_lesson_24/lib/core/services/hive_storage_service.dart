import 'package:flutter/material.dart' show ThemeMode;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/search/models/recent_search.dart';
import 'local_storage_service.dart';
import 'storage_keys.dart';

final class HiveStorageService implements LocalStorageService {
  late final SharedPreferences  _prefs;
  late final Box<RecentSearch>  _recentBox;

  Future<void> init() async {
    _prefs     = await SharedPreferences.getInstance();
    _recentBox = await Hive.openBox<RecentSearch>(
        StorageKeys.recentSearchesBox);
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final label = switch (mode) {
      ThemeMode.light  => 'light',
      ThemeMode.dark   => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(StorageKeys.themeMode, label);
  }

  @override
  Future<ThemeMode> loadThemeMode() async {
    final v = _prefs.getString(StorageKeys.themeMode) ??
        StorageKeys.defaultThemeMode;
    return switch (v) {
      'light' => ThemeMode.light,
      'dark'  => ThemeMode.dark,
      _       => ThemeMode.system,
    };
  }

  @override
  Future<void> saveCurrencyCode(String code) async =>
      _prefs.setString(StorageKeys.currencyCode, code);

  @override
  Future<String> loadCurrencyCode() async =>
      _prefs.getString(StorageKeys.currencyCode) ??
      StorageKeys.defaultCurrency;

  @override
  Future<void> addRecentSearch(RecentSearch search) async {
    final all = _recentBox.values.toList();
    all.removeWhere((s) =>
        s.originIata      == search.originIata &&
        s.destinationIata == search.destinationIata);
    all.insert(0, search);
    final trimmed = all.take(StorageKeys.maxRecentSearches).toList();
    await _recentBox.clear();
    await _recentBox.addAll(trimmed);
  }

  @override
  Future<List<RecentSearch>> loadRecentSearches() async =>
      _recentBox.values.toList();

  @override
  Future<void> clearRecentSearches() async => _recentBox.clear();

  @override
  Future<void> dispose() async => _recentBox.close();
}
