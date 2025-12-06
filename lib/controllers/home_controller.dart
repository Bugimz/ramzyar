import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';
import 'password_controller.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  late final TabController tabController;
  final RxInt tabIndex = 0.obs;

  final AuthController auth = Get.find<AuthController>();
  final PasswordController passwords = Get.find<PasswordController>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });
  }

  void onTabTapped(int index) {
    tabController.animateTo(index);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
