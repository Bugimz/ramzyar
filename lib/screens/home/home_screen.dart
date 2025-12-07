import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import 'widgets/generator_view.dart';
import 'widgets/vault_view.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // تنظیم رنگ status bar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Obx(() {
      final isVaultTab = controller.tabIndex.value == 0;

      return Scaffold(
        backgroundColor: colorScheme.background,
        extendBody: true,
        body: SafeArea(
          bottom: false,
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
        floatingActionButton: isVaultTab
            ? _FloatingAddButton(
                colorScheme: colorScheme,
                onPressed: () => Get.toNamed(Routes.addEditPassword),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        bottomNavigationBar: _BottomNavBar(
          isVaultTab: isVaultTab,
          colorScheme: colorScheme,
          isDark: isDark,
          onTabChanged: controller.onTabTapped,
        ),
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Bottom Navigation Bar - Glass morphism style
// ═══════════════════════════════════════════════════════════════

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.isVaultTab,
    required this.colorScheme,
    required this.isDark,
    required this.onTabChanged,
  });

  final bool isVaultTab;
  final ColorScheme colorScheme;
  final bool isDark;
  final Function(int) onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _NavItem(
                    icon: Icons.shield_outlined,
                    activeIcon: Icons.shield_rounded,
                    label: 'والت‌ها',
                    isSelected: isVaultTab,
                    colorScheme: colorScheme,
                    onTap: () => onTabChanged(0),
                  ),
                ),
                // Center divider
                Container(
                  width: 1,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.outlineVariant.withOpacity(0),
                        colorScheme.outlineVariant.withOpacity(0.3),
                        colorScheme.outlineVariant.withOpacity(0),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.auto_awesome_outlined,
                    activeIcon: Icons.auto_awesome_rounded,
                    label: 'سازنده',
                    isSelected: !isVaultTab,
                    colorScheme: colorScheme,
                    onTap: () => onTabChanged(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Navigation Item - Smooth animated nav item
// ═══════════════════════════════════════════════════════════════

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.colorScheme,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: colorScheme.primary.withOpacity(0.1),
        highlightColor: colorScheme.primary.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer.withOpacity(0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey(isSelected),
                  size: 22,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: SizedBox(width: isSelected ? 8 : 0),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: isSelected
                    ? Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Floating Add Button - Premium animated FAB
// ═══════════════════════════════════════════════════════════════

class _FloatingAddButton extends StatefulWidget {
  const _FloatingAddButton({
    required this.colorScheme,
    required this.onPressed,
  });

  final ColorScheme colorScheme;
  final VoidCallback onPressed;

  @override
  State<_FloatingAddButton> createState() => _FloatingAddButtonState();
}

class _FloatingAddButtonState extends State<_FloatingAddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _glowAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnim = Tween<double>(
      begin: 0.3,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.92 : _scaleAnim.value,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.colorScheme.primary,
                    widget.colorScheme.primary.withBlue(
                      (widget.colorScheme.primary.blue + 30).clamp(0, 255),
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  // Main shadow
                  BoxShadow(
                    color: widget.colorScheme.primary.withOpacity(
                      _glowAnim.value,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                  // Inner glow
                  BoxShadow(
                    color: widget.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Subtle shine effect
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 16,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Icon
                  Icon(
                    Icons.add_rounded,
                    color: widget.colorScheme.onPrimary,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
