import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import 'auth_controller.dart';

class LockController extends GetxController {
  final TextEditingController pinController = TextEditingController();
  final AuthController auth = Get.find<AuthController>();
  Worker? _authWorker;

  @override
  void onInit() {
    super.onInit();
    _authWorker = ever<bool>(auth.isAuthenticated, (authed) {
      if (authed) {
        Get.offAllNamed(Routes.root);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    auth.tryAutoBiometric();
  }

  Future<void> submitPin() async {
    await auth.validatePin(pinController.text.trim());
  }

  Future<void> authenticateBiometric() async {
    await auth.authenticateWithBiometrics();
  }

  @override
  void onClose() {
    _authWorker?.dispose();
    pinController.dispose();
    super.onClose();
  }
}
