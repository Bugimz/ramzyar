import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';
import 'password_controller.dart';

/// کنترلر صفحه اصلی
///
/// مسئول:
/// - مدیریت TabBar برای vault و generator
/// - دسترسی به کنترلرهای auth و passwords
class HomeController extends GetxController with SingleGetTickerProviderMixin {
  /// کنترلر تب‌ها
  late final TabController tabController;

  /// ایندکس تب فعلی (0: vault, 1: generator)
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

  /// تغییر تب با انیمیشن
  void onTabTapped(int index) {
    tabController.animateTo(index);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
