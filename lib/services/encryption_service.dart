import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// سرویس رمزنگاری برای ذخیره امن پسوردها
///
/// از الگوریتم AES-256-CBC استفاده می‌کند و کلید رمزنگاری را
/// در Secure Storage ذخیره می‌کند.
class EncryptionService {
  EncryptionService._internal();
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;

  static const _keyStorageKey = 'encryption_key';
  static const _ivStorageKey = 'encryption_iv';
  final _storage = const FlutterSecureStorage();

  Key? _key;
  IV? _iv;

  /// مقداردهی اولیه کلید رمزنگاری
  ///
  /// باید قبل از استفاده از [encrypt] یا [decrypt] فراخوانی شود.
  Future<void> initialize() async {
    if (_key != null && _iv != null) return;

    String? storedKey = await _storage.read(key: _keyStorageKey);
    String? storedIv = await _storage.read(key: _ivStorageKey);

    if (storedKey == null || storedIv == null) {
      // ایجاد کلید و IV جدید
      _key = Key.fromSecureRandom(32); // 256-bit key
      _iv = IV.fromSecureRandom(16); // 128-bit IV

      await _storage.write(
        key: _keyStorageKey,
        value: base64.encode(_key!.bytes),
      );
      await _storage.write(
        key: _ivStorageKey,
        value: base64.encode(_iv!.bytes),
      );
    } else {
      _key = Key(base64.decode(storedKey));
      _iv = IV(base64.decode(storedIv));
    }
  }

  /// رمزنگاری متن
  ///
  /// [plainText] متن ساده برای رمزنگاری
  /// خروجی: متن رمزنگاری شده به صورت Base64
  String encrypt(String plainText) {
    if (_key == null || _iv == null) {
      throw StateError('EncryptionService باید قبل از استفاده initialize شود');
    }

    final encrypter = Encrypter(AES(_key!, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// رمزگشایی متن
  ///
  /// [encryptedText] متن رمزنگاری شده به صورت Base64
  /// خروجی: متن ساده
  String decrypt(String encryptedText) {
    if (_key == null || _iv == null) {
      throw StateError('EncryptionService باید قبل از استفاده initialize شود');
    }

    try {
      final encrypter = Encrypter(AES(_key!, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
      return decrypted;
    } catch (e) {
      // اگر رمزگشایی شکست خورد، احتمالاً داده قدیمی بدون رمزنگاری است
      return encryptedText;
    }
  }

  /// بررسی اینکه آیا متن رمزنگاری شده است
  bool isEncrypted(String text) {
    try {
      base64.decode(text);
      return text.length > 20 && !text.contains(' ');
    } catch (_) {
      return false;
    }
  }
}
