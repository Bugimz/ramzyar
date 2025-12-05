import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import 'home/home_screen.dart';
import 'lock_screen.dart';
import 'setup_pin_screen.dart';

class RootRouter extends StatelessWidget {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      if (!auth.hasPin.value) {
        return const SetupPinScreen();
      }
      if (!auth.isAuthenticated.value) {
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
