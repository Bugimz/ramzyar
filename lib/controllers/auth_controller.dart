import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class AuthController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  final RxBool hasPin = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool biometricEnabled = false.obs;
  final RxBool biometricAvailable = false.obs;
  final RxString errorMessage = ''.obs;

  bool _autoBiometricTried = false;

  static const _pinKey = 'pin_code';
  static const _biometricKey = 'biometric_enabled';

  @override
  void onInit() {
    super.onInit();
    _loadState();
  }

  Future<void> _loadState() async {
    final storedPin = await _storage.read(key: _pinKey);
    hasPin.value = storedPin != null;
    biometricEnabled.value = (await _storage.read(key: _biometricKey)) == 'true';
    biometricAvailable.value = await _localAuthentication.canCheckBiometrics;

    if (hasPin.value && biometricEnabled.value) {
      await tryAutoBiometric();
    }
  }

  Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    hasPin.value = true;
    isAuthenticated.value = true;
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
  }
}
