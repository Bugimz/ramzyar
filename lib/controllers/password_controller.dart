import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/password_entry.dart';
import '../services/db_service.dart';
import '../services/background_monitor_service.dart';
import '../services/autofill_bridge.dart';
import '../services/permissions_service.dart';

class PasswordController extends GetxController {
  final DbService _dbService = DbService();
  final RxList<PasswordEntry> entries = <PasswordEntry>[].obs;
  final RxString searchTerm = ''.obs;
  final RxBool autoPromptEnabled = false.obs;

  Timer? _clipboardTimer;
  String? _lastClipboard; // prevents multiple prompts for same data
  bool _dialogVisible = false;

  @override
  void onInit() {
    super.onInit();
    loadEntries();
    _loadAutoPrompt();
  }

  Future<void> loadEntries() async {
    final data = await _dbService.fetchEntries();
    entries.assignAll(data);
  }

  Future<void> addEntry(PasswordEntry entry) async {
    await _dbService.insertEntry(entry);
    await AutofillBridge.cacheEntry(entry);
    await loadEntries();
  }

  Future<void> updateEntry(PasswordEntry entry) async {
    await _dbService.updateEntry(entry);
    await AutofillBridge.cacheEntry(entry);
    await loadEntries();
  }

  Future<void> deleteEntry(int id) async {
    await _dbService.deleteEntry(id);
    await loadEntries();
  }

  List<PasswordEntry> get filteredEntries {
    final term = searchTerm.value.trim();
    if (term.isEmpty) return entries;
    return entries
        .where((item) =>
            item.title.contains(term) ||
            item.username.contains(term) ||
            (item.website?.contains(term) ?? false))
        .toList();
  }

  String generatePassword({
    int length = 16,
    bool useNumbers = true,
    bool useSymbols = true,
    bool useLowercase = true,
    bool useUppercase = true,
  }) {
    const numbers = '0123456789';
    const symbols = '!@#%^&*()_-+=[]{}|;:,.<>?';
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    var pool = '';
    if (useNumbers) pool += numbers;
    if (useSymbols) pool += symbols;
    if (useLowercase) pool += lower;
    if (useUppercase) pool += upper;

    if (pool.isEmpty) {
      return '';
    }

    final rand = Random.secure();
    return List.generate(length, (_) => pool[rand.nextInt(pool.length)]).join();
  }

  Future<void> _loadAutoPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    autoPromptEnabled.value = prefs.getBool('auto_prompt') ?? false;
    _toggleClipboardWatcher(autoPromptEnabled.value);
  }

  Future<void> setAutoPrompt(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    autoPromptEnabled.value = value;
    await prefs.setBool('auto_prompt', value);
    _toggleClipboardWatcher(value);
  }

  void _toggleClipboardWatcher(bool enabled) {
    _clipboardTimer?.cancel();
    _clipboardTimer = null;
    if (enabled) {
      PermissionsService.ensureSmsPermission();
      BackgroundMonitorService.ensureRunning(requestBatteryExemption: true);
      _clipboardTimer = Timer.periodic(const Duration(seconds: 8), (_) async {
        await _checkClipboardForCredentials();
      });
    } else {
      BackgroundMonitorService.stop();
    }
  }

  Future<void> _checkClipboardForCredentials() async {
    final data = await Clipboard.getData('text/plain');
    final text = data?.text?.trim();
    if (text == null || text.isEmpty || text == _lastClipboard) return;

    if (text.contains('@') && text.contains(':')) {
      _lastClipboard = text;
      if (_dialogVisible) return;
      _dialogVisible = true;
      Get.dialog(
        _ClipboardPrompt(
          content: text,
          onSave: (username, password) {
            addEntry(
              PasswordEntry(title: 'ورود سریع', username: username, password: password),
            );
            _dialogVisible = false;
          },
          onCancel: () {
            _dialogVisible = false;
            Get.back();
          },
        ),
      );
    }
  }

  @override
  void onClose() {
    _clipboardTimer?.cancel();
    super.onClose();
  }
}

class _ClipboardPrompt extends StatelessWidget {
  const _ClipboardPrompt({
    required this.content,
    required this.onSave,
    required this.onCancel,
  });

  final String content;
  final void Function(String username, String password) onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final parts = content.split(':');
    final username = parts.first.trim();
    final password = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';

    return AlertDialog(
      title: const Text('ذخیره رمز جدید؟'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('به نظر می‌رسد نام کاربری و رمز عبور جدیدی وارد کرده‌اید.'),
          const SizedBox(height: 12),
          Text('نام کاربری: $username'),
          Text('رمز عبور: $password'),
        ],
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('خیر')),
        ElevatedButton(
          onPressed: () {
            onSave(username, password);
            Get.back();
          },
          child: const Text('بله، ذخیره کن'),
        ),
      ],
    );
  }
}
