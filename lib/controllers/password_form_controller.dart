import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/password_entry.dart';
import 'password_controller.dart';

class PasswordFormController extends GetxController {
  final PasswordController passwords = Get.find<PasswordController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final RxBool showPassword = false.obs;
  PasswordEntry? entry;

  bool get isEditing => entry != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is PasswordEntry) {
      entry = args;
    }
    if (entry != null) {
      titleController.text = entry!.title;
      usernameController.text = entry!.username;
      passwordController.text = entry!.password;
      websiteController.text = entry!.website ?? '';
      notesController.text = entry!.notes ?? '';
    }
  }

  Future<void> save() async {
    if (titleController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar('خطا', 'عنوان، نام کاربری و رمز عبور الزامی است');
      return;
    }

    final updated = PasswordEntry(
      id: entry?.id,
      title: titleController.text.trim(),
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
      website: websiteController.text.trim().isEmpty ? null : websiteController.text.trim(),
      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      createdAt: entry?.createdAt,
    );

    if (entry == null) {
      await passwords.addEntry(updated);
    } else {
      await passwords.updateEntry(updated);
    }
    Get.back();
  }

  @override
  void onClose() {
    titleController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    websiteController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
