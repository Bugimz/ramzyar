import 'package:flutter/services.dart';

import '../models/password_entry.dart';

class AutofillBridge {
  static const _channel = MethodChannel('ramzyar/autofill');

  static Future<void> cacheEntry(PasswordEntry entry) async {
    if (entry.username.isEmpty || entry.password.isEmpty) return;
    await _channel.invokeMethod('cacheCredentials', {
      'username': entry.username,
      'password': entry.password,
    });
  }

  static Future<void> openSettings() async {
    await _channel.invokeMethod('openAutofillSettings');
  }
}
