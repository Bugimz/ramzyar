import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import 'widgets/navigation/bottom_nav_bar.dart';
import 'widgets/navigation/floating_add_button.dart';
import 'widgets/generator/generator_view.dart';
import 'widgets/vault/vault_view.dart';

/// صفحه اصلی برنامه
///
/// شامل دو تب:
/// - Vault: لیست پسوردها
/// - Generator: تولید پسورد تصادفی
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Obx(() {
      final isVaultTab = controller.tabIndex.value == 0;

      return Scaffold(
        backgroundColor: colorScheme.surface,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return TabBarView(
                controller: controller.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const VaultView(),
                  GeneratorView(maxWidth: constraints.maxWidth),
                ],
              );
            },
          ),
        ),
        floatingActionButton: isVaultTab
            ? FloatingAddButton(
                onPressed: () => Get.toNamed(Routes.addEditPassword),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        bottomNavigationBar: BottomNavBar(
          selectedIndex: controller.tabIndex.value,
          onTabChanged: controller.onTabTapped,
        ),
      );
    });
  }
}
