import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import 'home/home_screen.dart';
import 'lock/lock_screen.dart';
import 'setup_pin/setup_pin_screen.dart';

class RootRouter extends GetView<AuthController> {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasPin.value) {
        return const SetupPinScreen();
      }
      if (!controller.isAuthenticated.value) {
        return const LockScreen();
      }
      return const HomeScreen();
    });
  }

  static void redirect(AuthController auth) {
    if (!auth.hasPin.value) {
      Get.offAllNamed(Routes.setupPin);
    } else if (!auth.isAuthenticated.value) {
      Get.offAllNamed(Routes.lock);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }
}
