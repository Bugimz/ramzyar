import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'password_controller.dart';

/// کنترلر تولید رمز عبور تصادفی
///
/// امکانات:
/// - تنظیم طول رمز (8-32 کاراکتر)
/// - انتخاب نوع کاراکترها (اعداد/نمادها/حروف)
/// - کپی به کلیپ‌بورد
class GeneratorController extends GetxController {
  final PasswordController passwords = Get.find<PasswordController>();

  /// طول رمز عبور
  final RxInt length = 16.obs;

  /// تنظیمات کاراکترها
  final RxBool numbers = true.obs;
  final RxBool symbols = true.obs;
  final RxBool lower = true.obs;
  final RxBool upper = true.obs;

  /// رمز تولید شده
  final RxString generated = ''.obs;

  @override
  void onInit() {
    super.onInit();
    generate();
  }

  void updateLength(double value) {
    length.value = value.toInt();
    generate();
  }

  void toggleNumbers(bool value) {
    numbers.value = value;
    generate();
  }

  void toggleSymbols(bool value) {
    symbols.value = value;
    generate();
  }

  void toggleLower(bool value) {
    lower.value = value;
    generate();
  }

  void toggleUpper(bool value) {
    upper.value = value;
    generate();
  }

  void generate() {
    generated.value = passwords.generatePassword(
      length: length.value,
      useNumbers: numbers.value,
      useSymbols: symbols.value,
      useLowercase: lower.value,
      useUppercase: upper.value,
    );
  }

  Future<void> copyToClipboard() async {
    if (generated.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: generated.value));
    Get.snackbar('کپی شد', 'رمز در کلیپ‌بورد ذخیره شد');
  }
}
