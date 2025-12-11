import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// کنترلر احراز هویت - مدیریت PIN، بیومتریک و قفل خودکار
///
/// این کنترلر مسئول:
/// - ذخیره و اعتبارسنجی PIN
/// - احراز هویت بیومتریک
/// - قفل خودکار برنامه
/// - Rate limiting برای جلوگیری از حملات brute force
class AuthController extends GetxController with WidgetsBindingObserver {
  final _storage = const FlutterSecureStorage();
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  static const _securityChannel = MethodChannel('ramzyar/security');

  final RxBool hasPin = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool biometricEnabled = false.obs;
  final RxBool biometricAvailable = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt autoLockMinutes = 5.obs;
  final RxBool screenSecureEnabled = true.obs;

  // Rate limiting برای PIN
  final RxInt failedAttempts = 0.obs;
  final Rx<DateTime?> lockoutUntil = Rx<DateTime?>(null);
  static const int _maxFailedAttempts = 5;
  static const Duration _lockoutDuration = Duration(minutes: 5);

  bool _autoBiometricTried = false;
  Timer? _autoLockTimer;
  DateTime _lastInteraction = DateTime.now();

  // Cache برای SharedPreferences
  SharedPreferences? _prefs;

  static const _pinKey = 'pin_code';
  static const _biometricKey = 'biometric_enabled';
  static const _autoLockKey = 'auto_lock_minutes';
  static const _screenSecureKey = 'screen_secure_enabled';
  static const _failedAttemptsKey = 'failed_attempts';
  static const _lockoutUntilKey = 'lockout_until';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _loadState();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoLockTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadState() async {
    _prefs = await SharedPreferences.getInstance();
    final storedPin = await _storage.read(key: _pinKey);
    hasPin.value = storedPin != null;
    biometricEnabled.value =
        (await _storage.read(key: _biometricKey)) == 'true';
    biometricAvailable.value = await _localAuthentication.canCheckBiometrics;
    autoLockMinutes.value = _prefs!.getInt(_autoLockKey) ?? 5;
    screenSecureEnabled.value = _prefs!.getBool(_screenSecureKey) ?? true;

    // بارگذاری وضعیت Rate Limiting
    failedAttempts.value = _prefs!.getInt(_failedAttemptsKey) ?? 0;
    final lockoutMs = _prefs!.getInt(_lockoutUntilKey);
    if (lockoutMs != null) {
      lockoutUntil.value = DateTime.fromMillisecondsSinceEpoch(lockoutMs);
      if (DateTime.now().isAfter(lockoutUntil.value!)) {
        lockoutUntil.value = null;
        failedAttempts.value = 0;
        await _prefs!.remove(_lockoutUntilKey);
        await _prefs!.remove(_failedAttemptsKey);
      }
    }

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
    if (_autoBiometricTried ||
        !biometricEnabled.value ||
        !biometricAvailable.value) {
      return;
    }
    _autoBiometricTried = true;
    await authenticateWithBiometrics();
  }

  /// اعتبارسنجی PIN با Rate Limiting
  ///
  /// پس از [_maxFailedAttempts] تلاش ناموفق، کاربر به مدت
  /// [_lockoutDuration] قفل می‌شود.
  Future<bool> validatePin(String pin) async {
    // بررسی وضعیت قفل
    if (lockoutUntil.value != null &&
        DateTime.now().isBefore(lockoutUntil.value!)) {
      final remaining = lockoutUntil.value!.difference(DateTime.now());
      errorMessage.value = 'لطفاً ${remaining.inMinutes + 1} دقیقه صبر کنید';
      return false;
    }

    final storedPin = await _storage.read(key: _pinKey);
    if (storedPin == pin) {
      errorMessage.value = '';
      isAuthenticated.value = true;
      // ریست کردن تلاش‌های ناموفق
      failedAttempts.value = 0;
      await _prefs?.remove(_failedAttemptsKey);
      await _prefs?.remove(_lockoutUntilKey);
      _resetAutoLockTimer();
      return true;
    }

    // افزایش تعداد تلاش‌های ناموفق
    failedAttempts.value++;
    await _prefs?.setInt(_failedAttemptsKey, failedAttempts.value);

    if (failedAttempts.value >= _maxFailedAttempts) {
      lockoutUntil.value = DateTime.now().add(_lockoutDuration);
      await _prefs?.setInt(
        _lockoutUntilKey,
        lockoutUntil.value!.millisecondsSinceEpoch,
      );
      errorMessage.value =
          'تعداد تلاش‌ها بیش از حد مجاز است. لطفاً ${_lockoutDuration.inMinutes} دقیقه صبر کنید';
    } else {
      final remaining = _maxFailedAttempts - failedAttempts.value;
      errorMessage.value = 'رمز عبور نادرست است ($remaining تلاش باقیمانده)';
    }
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

  /// تنظیم زمان قفل خودکار (دقیقه)
  Future<void> setAutoLockMinutes(int minutes) async {
    autoLockMinutes.value = minutes;
    await _prefs?.setInt(_autoLockKey, minutes);
    if (isAuthenticated.value) {
      _resetAutoLockTimer();
    }
  }

  /// فعال/غیرفعال کردن امنیت صفحه (جلوگیری از اسکرین‌شات)
  Future<void> toggleScreenSecure(bool enabled) async {
    screenSecureEnabled.value = enabled;
    await _prefs?.setBool(_screenSecureKey, enabled);
    await _applyScreenSecure(enabled);
  }

  void markActivity() {
    if (isAuthenticated.value) {
      _lastInteraction = DateTime.now();
      _resetAutoLockTimer();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _lastInteraction = DateTime.now();
      _autoLockTimer?.cancel();
      return;
    }

    if (state == AppLifecycleState.resumed && isAuthenticated.value) {
      final elapsed = DateTime.now().difference(_lastInteraction);
      final limit = Duration(minutes: autoLockMinutes.value);
      if (autoLockMinutes.value > 0 && elapsed >= limit) {
        lockApp();
      } else {
        final remaining = autoLockMinutes.value > 0
            ? limit - elapsed
            : Duration.zero;
        _resetAutoLockTimer(customDuration: remaining);
      }
    }
  }

  Future<void> _applyScreenSecure(bool enabled) async {
    try {
      await _securityChannel.invokeMethod('setSecure', {'enabled': enabled});
    } catch (_) {
      // ignore platform-specific failures
    }
  }

  void _resetAutoLockTimer({Duration? customDuration}) {
    _autoLockTimer?.cancel();
    if (autoLockMinutes.value <= 0) return;
    final duration = customDuration ?? Duration(minutes: autoLockMinutes.value);
    _lastInteraction = DateTime.now();
    _autoLockTimer = Timer(duration, () async {
      await lockApp();
    });
  }
}
