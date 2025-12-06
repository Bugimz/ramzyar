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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isVaultTab = controller.tabIndex.value == 0;
      return Scaffold(
        backgroundColor: surface,
        extendBody: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Tab Content
                  TabBarView(
                    controller: controller.tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const VaultView(),
                      GeneratorView(maxWidth: constraints.maxWidth),
                    ],
                  ),
                  
                  // Floating Action Button - Custom positioned
                  if (isVaultTab)
                    Positioned(
                      bottom: 90,
                      left: 24,
                      child: _AnimatedFAB(
                        colorScheme: colorScheme,
                        isDark: isDark,
                        onPressed: () => Get.toNamed(Routes.addEditPassword),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: _buildBottomNav(context, colorScheme, isDark),
      );
    });
  }

  Widget _buildBottomNav(BuildContext context, ColorScheme colorScheme, bool isDark) {
    final isVaultTab = controller.tabIndex.value == 0;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
          if (!isDark)
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.05),
              blurRadius: 30,
              offset: const Offset(0, -5),
              spreadRadius: 5,
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavItem(
            icon: Icons.lock_outline,
            activeIcon: Icons.lock_rounded,
            label: 'والت‌ها',
            selected: isVaultTab,
            onTap: () => controller.onTabTapped(0),
            colorScheme: colorScheme,
          ),
          // Center Spacer for FAB
          if (isVaultTab) const SizedBox(width: 56),
          BottomNavItem(
            icon: Icons.password_outlined,
            activeIcon: Icons.password_rounded,
            label: 'سازنده رمز',
            selected: !isVaultTab,
            onTap: () => controller.onTabTapped(1),
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class _AnimatedFAB extends StatefulWidget {
  const _AnimatedFAB({
    required this.colorScheme,
    required this.isDark,
    required this.onPressed,
  });

  final ColorScheme colorScheme;
  final bool isDark;
  final VoidCallback onPressed;

  @override
  State<_AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<_AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 3.14159,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.colorScheme.primary,
                      widget.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.colorScheme.primary.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: widget.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: widget.colorScheme.onPrimary,
                  size: 32,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
