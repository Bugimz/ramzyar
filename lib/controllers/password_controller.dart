import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/password_entry.dart';
import '../services/db_service.dart';
import '../services/background_monitor_service.dart';
import '../services/autofill_bridge.dart';
import '../services/permissions_service.dart';
import '../screens/home/widgets/common/clipboard_prompt_dialog.dart';

/// کنترلر مدیریت پسوردها
///
/// مسئولیت‌ها:
/// - CRUD پسوردها
/// - جستجو
/// - تولید پسورد تصادفی
/// - پشتیبانی از Auto-fill
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

  /// بارگذاری تمام entries از دیتابیس
  Future<void> loadEntries() async {
    final data = await _dbService.fetchEntries();
    entries.assignAll(data);
  }

  /// افزودن entry جدید - بهینه‌سازی شده برای جلوگیری از reload کامل
  Future<void> addEntry(PasswordEntry entry) async {
    final id = await _dbService.insertEntry(entry);
    if (id > 0) {
      // اضافه کردن به ابتدای لیست بدون نیاز به reload
      final newEntry = entry.copyWith(id: id);
      entries.insert(0, newEntry);
      await AutofillBridge.cacheEntry(newEntry);
    }
  }

  /// به‌روزرسانی entry - بهینه‌سازی شده
  Future<void> updateEntry(PasswordEntry entry) async {
    final result = await _dbService.updateEntry(entry);
    if (result > 0) {
      // به‌روزرسانی در لیست بدون reload
      final index = entries.indexWhere((e) => e.id == entry.id);
      if (index >= 0) {
        entries[index] = entry;
      }
      await AutofillBridge.cacheEntry(entry);
    }
  }

  /// حذف entry - بهینه‌سازی شده
  Future<void> deleteEntry(int id) async {
    final result = await _dbService.deleteEntry(id);
    if (result > 0) {
      // حذف از لیست بدون reload
      entries.removeWhere((e) => e.id == id);
    }
  }

  List<PasswordEntry> get filteredEntries {
    final term = searchTerm.value.trim();
    if (term.isEmpty) return entries;
    return entries
        .where(
          (item) =>
              item.title.contains(term) ||
              item.username.contains(term) ||
              (item.website?.contains(term) ?? false),
        )
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
        ClipboardPromptDialog(
          content: text,
          onSave: (username, password) {
            addEntry(
              PasswordEntry(
                title: 'ورود سریع',
                username: username,
                password: password,
              ),
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
