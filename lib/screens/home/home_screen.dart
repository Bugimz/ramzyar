import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/generator_view.dart';
import 'widgets/vault_view.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surface = Theme.of(context).scaffoldBackgroundColor;

    return Obx(() {
      final isVaultTab = controller.tabIndex.value == 0;
      return Scaffold(
        backgroundColor: surface,
        extendBody: true,
        body: SafeArea(
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
            ? FloatingActionButton(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                onPressed: () => Get.toNamed(Routes.addEditPassword),
                child: const Icon(Icons.add_rounded, size: 30),
              )
            : null,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavItem(
                icon: Icons.lock_outline,
                label: 'والت‌ها',
                selected: isVaultTab,
                onTap: () => controller.onTabTapped(0),
              ),
              BottomNavItem(
                icon: Icons.password_rounded,
                label: 'سازنده رمز',
                selected: !isVaultTab,
                onTap: () => controller.onTabTapped(1),
              ),
            ],
          ),
        ),
      );
    });
  }
}
