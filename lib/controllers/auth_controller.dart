import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  final RxBool hasPin = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool biometricEnabled = false.obs;
  final RxBool biometricAvailable = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt autoLockMinutes = 5.obs;
  final RxBool screenSecureEnabled = true.obs;

  bool _autoBiometricTried = false;
  Timer? _autoLockTimer;

  static const _pinKey = 'pin_code';
  static const _biometricKey = 'biometric_enabled';
  static const _autoLockKey = 'auto_lock_minutes';
  static const _screenSecureKey = 'screen_secure_enabled';

  @override
  void onInit() {
    super.onInit();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = await _storage.read(key: _pinKey);
    hasPin.value = storedPin != null;
    biometricEnabled.value = (await _storage.read(key: _biometricKey)) == 'true';
    biometricAvailable.value = await _localAuthentication.canCheckBiometrics;
    autoLockMinutes.value = prefs.getInt(_autoLockKey) ?? 5;
    screenSecureEnabled.value = prefs.getBool(_screenSecureKey) ?? true;

    if (screenSecureEnabled.value) {
      await _applyScreenSecure(true);
    }

    if (hasPin.value && biometricEnabled.value) {
      await tryAutoBiometric();
    }
  }

  Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    hasPin.value = true;
    isAuthenticated.value = true;
    _resetAutoLockTimer();
  }

  Future<void> tryAutoBiometric() async {
    if (_autoBiometricTried || !biometricEnabled.value || !biometricAvailable.value) {
      return;
    }
    _autoBiometricTried = true;
    await authenticateWithBiometrics();
  }

  Future<bool> validatePin(String pin) async {
    final storedPin = await _storage.read(key: _pinKey);
    if (storedPin == pin) {
      errorMessage.value = '';
      isAuthenticated.value = true;
      _resetAutoLockTimer();
      return true;
    }
    errorMessage.value = 'رمز عبور نادرست است';
    return false;
  }

  Future<void> toggleBiometrics(bool enable) async {
    biometricEnabled.value = enable;
    await _storage.write(key: _biometricKey, value: enable.toString());
  }

  Future<bool> authenticateWithBiometrics() async {
    if (!biometricEnabled.value || !biometricAvailable.value) {
      return false;
    }
    try {
      final didAuthenticate = await _localAuthentication.authenticate(
        localizedReason: 'ورود با اثر انگشت یا تشخیص چهره',
        biometricOnly: true,
      );
      if (didAuthenticate) {
        isAuthenticated.value = true;
        _resetAutoLockTimer();
      }
      return didAuthenticate;
    } on PlatformException catch (error) {
      errorMessage.value = error.message ?? 'خطا در احراز هویت بیومتریک';
      return false;
    }
  }

  Future<void> lockApp() async {
    isAuthenticated.value = false;
    _autoBiometricTried = false;
    _autoLockTimer?.cancel();
  }

  Future<void> setAutoLockMinutes(int minutes) async {
    autoLockMinutes.value = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_autoLockKey, minutes);
    if (isAuthenticated.value) {
      _resetAutoLockTimer();
    }
  }

  Future<void> toggleScreenSecure(bool enabled) async {
    screenSecureEnabled.value = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_screenSecureKey, enabled);
    await _applyScreenSecure(enabled);
  }

  void markActivity() {
    if (isAuthenticated.value) {
      _resetAutoLockTimer();
    }
  }

  Future<void> _applyScreenSecure(bool enabled) async {
    try {
      if (enabled) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      } else {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      }
    } catch (_) {
      // ignore platform-specific failures
    }
  }

  void _resetAutoLockTimer() {
    _autoLockTimer?.cancel();
    if (autoLockMinutes.value <= 0) return;
    _autoLockTimer = Timer(Duration(minutes: autoLockMinutes.value), () async {
      await lockApp();
    });
  }
}
