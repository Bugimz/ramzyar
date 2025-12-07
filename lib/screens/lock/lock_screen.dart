import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/lock_controller.dart';
import 'widgets/lock_form.dart';

class LockScreen extends GetView<LockController> {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // 🔷 Background
          _Background(colorScheme: colorScheme, isDark: isDark),

          // 🔷 Decorative Orbs
          const _FloatingOrbs(),

          // 🔷 Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;

                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 48 : 24,
                      vertical: 32,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo
                          _Logo(colorScheme: colorScheme),

                          SizedBox(height: size.height * 0.05),

                          // Lock Card (شامل فرم)
                          _LockCard(isDark: isDark),

                          const SizedBox(height: 32),

                          // Footer
                          _Footer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Background
// ═══════════════════════════════════════════════════════════════

class _Background extends StatelessWidget {
  const _Background({required this.colorScheme, required this.isDark});

  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0F0F23),
                  const Color(0xFF1A1A2E),
                  const Color(0xFF16213E),
                ]
              : [
                  colorScheme.primary,
                  colorScheme.primary.withOpacity(0.8),
                  colorScheme.secondary,
                ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Floating Orbs
// ═══════════════════════════════════════════════════════════════

class _FloatingOrbs extends StatelessWidget {
  const _FloatingOrbs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: -80, right: -60, child: _Orb(size: 200, opacity: 0.15)),
        Positioned(
          bottom: -100,
          left: -80,
          child: _Orb(size: 250, opacity: 0.1),
        ),
        Positioned(top: 150, left: 50, child: _Orb(size: 100, opacity: 0.08)),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(opacity),
            Colors.white.withOpacity(0),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Logo
// ═══════════════════════════════════════════════════════════════

class _Logo extends StatelessWidget {
  const _Logo({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.shield_rounded, size: 40, color: colorScheme.primary),
              Positioned(
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Name
        const Text(
          'رمزیار',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          'مدیریت امن رمزهای عبور',
          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6)),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Lock Card
// ═══════════════════════════════════════════════════════════════

class _LockCard extends StatelessWidget {
  const _LockCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isDark ? 0.08 : 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lock_open_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ورود به حساب',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'رمز ۴ رقمی خود را وارد کنید',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔷 Form - همه چیز اینجاست
              const LockForm(),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Footer
// ═══════════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user_rounded,
            size: 14,
            color: Colors.greenAccent.withOpacity(0.8),
          ),
          const SizedBox(width: 6),
          Text(
            'AES-256',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
