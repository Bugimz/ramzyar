import 'package:flutter/services.dart';

class BackgroundMonitorService {
  static const _channel = MethodChannel('ramzyar/background');

  static Future<void> ensureRunning({bool requestBatteryExemption = false}) async {
    try {
      await _channel.invokeMethod('startService', {
        'requestBattery': requestBatteryExemption,
      });
    } catch (_) {
      // No-op: service channel may be unavailable on unsupported platforms.
    }
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stopService');
    } catch (_) {
      // Ignore failures when channel not ready.
    }
  }
}
