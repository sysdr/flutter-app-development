import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kThemeMode = 'nomadair.theme_mode';
const String _kLaunchCount = 'nomadair.launch_count';

abstract interface class ThemePreferenceService {
  Future<ThemeMode> loadThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
  Future<void> clearThemeMode();
  Future<int> getLaunchCount();
  Future<ThemeMode> getSavedThemeMode();
}

final class SharedPrefsThemeService implements ThemePreferenceService {
  const SharedPrefsThemeService();

  @override
  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_kLaunchCount) ?? 0) + 1;
    await prefs.setInt(_kLaunchCount, count);

    final index = prefs.getInt(_kThemeMode);
    if (index == null || index < 0 || index >= ThemeMode.values.length) {
      return ThemeMode.system;
    }
    return ThemeMode.values[index];
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kThemeMode, mode.index);
  }

  @override
  Future<void> clearThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kThemeMode);
  }

  @override
  Future<int> getLaunchCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kLaunchCount) ?? 0;
  }

  @override
  Future<ThemeMode> getSavedThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_kThemeMode);
    if (index == null || index < 0 || index >= ThemeMode.values.length) {
      return ThemeMode.system;
    }
    return ThemeMode.values[index];
  }
}
