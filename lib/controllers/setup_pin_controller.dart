import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class SetupPinController extends GetxController {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final AuthController auth = Get.find<AuthController>();

  final RxBool saving = false.obs;
  final RxnString error = RxnString();
  final RxBool showPin = false.obs;
  final RxBool showConfirm = false.obs;

  Future<void> savePin() async {
    final pin = pinController.text.trim();
    final confirm = confirmController.text.trim();

    if (pin.length < 4) {
      error.value = 'حداقل چهار رقم وارد کنید';
      return;
    }
    if (pin != confirm) {
      error.value = 'رمزها یکسان نیستند';
      return;
    }

    saving.value = true;
    await auth.setPin(pin);
    saving.value = false;
    error.value = null;
  }

  @override
  void onClose() {
    pinController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
