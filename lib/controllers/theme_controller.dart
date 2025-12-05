import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  static const _prefKey = 'theme_mode';

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff5169f6)),
        scaffoldBackgroundColor: const Color(0xfff4f6fb),
        useMaterial3: true,
        chipTheme: const ChipThemeData(side: BorderSide.none),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff8ba2ff),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xff0f1118),
        useMaterial3: true,
        chipTheme: const ChipThemeData(side: BorderSide.none),
      );

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefKey);
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

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    final prefs = await SharedPreferences.getInstance();
    final value = mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.system
            ? 'system'
            : 'light';
    await prefs.setString(_prefKey, value);
  }

  Future<void> toggleDark(bool enabled) async {
    await setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }
}
