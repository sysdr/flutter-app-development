import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeKey='nomadair.theme_mode';
const _kLaunchKey='nomadair.launch_count';

abstract interface class ThemePreferenceService{
  Future<ThemeMode> load();Future<void> save(ThemeMode m);
  Future<void> clear();Future<int> launchCount();
}

final class SharedPrefsThemeService implements ThemePreferenceService{
  SharedPrefsThemeService._();
  static SharedPrefsThemeService? _instance;
  static Future<SharedPrefsThemeService> create() async{_instance??=SharedPrefsThemeService._();return _instance!;}
  @override Future<ThemeMode> load() async{final p=await SharedPreferences.getInstance();final c=(p.getInt(_kLaunchKey)??0)+1;await p.setInt(_kLaunchKey,c);final i=p.getInt(_kThemeKey);if(i==null||i<0||i>=ThemeMode.values.length)return ThemeMode.system;return ThemeMode.values[i];}
  @override Future<void> save(ThemeMode m) async{final p=await SharedPreferences.getInstance();await p.setInt(_kThemeKey,m.index);}
  @override Future<void> clear() async{final p=await SharedPreferences.getInstance();await p.remove(_kThemeKey);}
  @override Future<int> launchCount() async{final p=await SharedPreferences.getInstance();return p.getInt(_kLaunchKey)??0;}
}
