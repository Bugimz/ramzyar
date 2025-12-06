import 'package:flutter/services.dart';

class PermissionsService {
  static const _channel = MethodChannel('ramzyar/permissions');

  static Future<void> ensureSmsPermission() async {
    try {
      await _channel.invokeMethod('requestSms');
    } catch (_) {
      // Native channel may not be available (e.g., on iOS or web).
    }
  }
}
