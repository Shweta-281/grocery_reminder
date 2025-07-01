import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {
  static const _themeBox = 'themeBox';
  static const _isDarkKey = 'isDark';

  bool _isDark = false;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDark => _isDark;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> _loadTheme() async {
    final box = await Hive.openBox(_themeBox);
    _isDark = box.get(_isDarkKey, defaultValue: false);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    final box = await Hive.openBox(_themeBox);
    await box.put(_isDarkKey, _isDark);
    notifyListeners();
  }
}