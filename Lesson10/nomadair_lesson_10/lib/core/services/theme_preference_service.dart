import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeKey  = 'nomadair.theme_mode';
const _kLaunchKey = 'nomadair.launch_count';

abstract interface class ThemePreferenceService {
  Future<ThemeMode> load();
  Future<void> save(ThemeMode mode);
  Future<void> clear();
  Future<int>  launchCount();
}

final class SharedPrefsThemeService implements ThemePreferenceService {
  SharedPrefsThemeService._();
  static SharedPrefsThemeService? _instance;

  static Future<SharedPrefsThemeService> create() async {
    _instance ??= SharedPrefsThemeService._();
    return _instance!;
  }

  @override
  Future<ThemeMode> load() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_kLaunchKey) ?? 0) + 1;
    await prefs.setInt(_kLaunchKey, count);
    final index = prefs.getInt(_kThemeKey);
    if (index == null || index < 0 || index >= ThemeMode.values.length)
      return ThemeMode.system;
    return ThemeMode.values[index];
  }

  @override
  Future<void> save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kThemeKey, mode.index);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kThemeKey);
  }

  @override
  Future<int> launchCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kLaunchKey) ?? 0;
  }
}
