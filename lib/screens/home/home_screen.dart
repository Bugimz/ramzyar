import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/password_controller.dart';
import '../../routes/app_routes.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/generator_view.dart';
import 'widgets/vault_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  final AuthController auth = Get.find<AuthController>();
  final PasswordController passwordController = Get.find<PasswordController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  void _onTabTapped(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final isVaultTab = _tabController.index == 0;
    final colorScheme = Theme.of(context).colorScheme;
    final surface = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: surface,
      extendBody: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                VaultView(controller: passwordController, auth: auth),
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
              onTap: () => _onTabTapped(0),
            ),
            BottomNavItem(
              icon: Icons.password_rounded,
              label: 'سازنده رمز',
              selected: !isVaultTab,
              onTap: () => _onTabTapped(1),
            ),
          ],
        ),
      ),
    );
  }
}
