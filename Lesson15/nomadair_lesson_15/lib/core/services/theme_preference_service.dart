import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
const _kT='nomadair.theme_mode',_kL='nomadair.launch_count';
abstract interface class ThemePreferenceService{Future<ThemeMode> load();Future<void> save(ThemeMode m);Future<void> clear();Future<int> launchCount();}
final class SharedPrefsThemeService implements ThemePreferenceService{
  SharedPrefsThemeService._();static SharedPrefsThemeService? _instance;
  static Future<SharedPrefsThemeService> create()async{_instance??=SharedPrefsThemeService._();return _instance!;}
  /// For integration/widget tests that invoke `main()` repeatedly.
  static void resetSingletonForTest(){_instance=null;}
  @override Future<ThemeMode> load()async{final p=await SharedPreferences.getInstance();final c=(p.getInt(_kL)??0)+1;await p.setInt(_kL,c);final i=p.getInt(_kT);if(i==null||i<0||i>=ThemeMode.values.length)return ThemeMode.system;return ThemeMode.values[i];}
  @override Future<void> save(ThemeMode m)async{final p=await SharedPreferences.getInstance();await p.setInt(_kT,m.index);}
  @override Future<void> clear()async{final p=await SharedPreferences.getInstance();await p.remove(_kT);}
  @override Future<int> launchCount()async{final p=await SharedPreferences.getInstance();return p.getInt(_kL)??0;}
}
