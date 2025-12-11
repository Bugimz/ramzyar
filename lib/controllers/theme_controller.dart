import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// کنترلر مدیریت تم برنامه
///
/// مسئول:
/// - ذخیره و بازیابی تنظیمات تم
/// - ارائه ThemeData برای تم روشن و تاریک
/// - تغییر تم در زمان اجرا
class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  static const _prefKey = 'theme_mode';

  // Cache برای SharedPreferences
  SharedPreferences? _prefs;

  // Cache برای ThemeData
  ThemeData? _lightThemeCache;
  ThemeData? _darkThemeCache;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  /// تم روشن با رنگ اصلی آبی
  ThemeData get lightTheme {
    _lightThemeCache ??= ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff5169f6)),
      scaffoldBackgroundColor: const Color(0xfff4f6fb),
      useMaterial3: true,
      chipTheme: const ChipThemeData(side: BorderSide.none),
    );
    return _lightThemeCache!;
  }

  /// تم تاریک با رنگ اصلی آبی روشن
  ThemeData get darkTheme {
    _darkThemeCache ??= ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff8ba2ff),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xff0f1118),
      useMaterial3: true,
      chipTheme: const ChipThemeData(side: BorderSide.none),
    );
    return _darkThemeCache!;
  }

  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs!.getString(_prefKey);
    switch (stored) {
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      case 'system':
        themeMode.value = ThemeMode.system;
        break;
      default:
        themeMode.value = ThemeMode.light;
    }
  }

  /// تغییر حالت تم
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    final value = mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.system
        ? 'system'
        : 'light';
    await _prefs?.setString(_prefKey, value);
  }

  /// فعال/غیرفعال کردن تم تاریک
  Future<void> toggleDark(bool enabled) async {
    await setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }
}
