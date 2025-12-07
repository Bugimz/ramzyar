import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../models/password_entry.dart';
import '../../../routes/app_routes.dart';
import 'security_sheet.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    super.key,
    required this.auth,
    required this.total,
    required this.recent,
    this.isWide = false,
  });

  final AuthController auth;
  final int total;
  final List<PasswordEntry> recent;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 400;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(isDark ? 0.3 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // 🔷 Top Section - Greeting & Actions
              Padding(
                padding: EdgeInsets.all(isWide ? 20 : 16),
                child: Row(
                  children: [
                    // Avatar/Badge
                    _AvatarBadge(colorScheme: colorScheme),
                    const SizedBox(width: 14),

                    // Greeting Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سلام، خوش برگشتی 👋',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'رمزهایت امن هستند',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Buttons
                    _CompactActions(auth: auth, colorScheme: colorScheme),
                  ],
                ),
              ),

              // 🔷 Stats Row
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 20 : 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    _MiniStat(
                      icon: Icons.folder_outlined,
                      value: '1',
                      label: 'والت',
                      colorScheme: colorScheme,
                    ),
                    _StatDivider(colorScheme: colorScheme),
                    _MiniStat(
                      icon: Icons.key_rounded,
                      value: '$total',
                      label: 'رمز',
                      colorScheme: colorScheme,
                    ),
                    _StatDivider(colorScheme: colorScheme),
                    _HealthIndicator(colorScheme: colorScheme),
                  ],
                ),
              ),

              // 🔷 Recent Section
              if (recent.isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(isWide ? 20 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'استفاده اخیر',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: recent
                            .map(
                              (e) => _RecentTag(
                                entry: e,
                                colorScheme: colorScheme,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Avatar Badge - Compact shield icon
// ═══════════════════════════════════════════════════════════════

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(Icons.shield_rounded, color: colorScheme.onPrimary, size: 24),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Compact Action Buttons
// ═══════════════════════════════════════════════════════════════

class _CompactActions extends StatelessWidget {
  const _CompactActions({required this.auth, required this.colorScheme});

  final AuthController auth;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SmallIconButton(
            icon: Icons.tune_rounded,
            tooltip: 'تنظیمات',
            colorScheme: colorScheme,
            onTap: () {
              Get.bottomSheet(
                const SecuritySheet(),
                isScrollControlled: true,
                backgroundColor: colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
              );
            },
          ),
          Container(
            width: 1,
            height: 20,
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
          _SmallIconButton(
            icon: Icons.lock_rounded,
            tooltip: 'قفل',
            colorScheme: colorScheme,
            onTap: () {
              auth.lockApp();
              Get.offAllNamed(Routes.lock);
            },
          ),
        ],
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  const _SmallIconButton({
    required this.icon,
    required this.tooltip,
    required this.colorScheme,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Mini Stat - Ultra compact stat display
// ═══════════════════════════════════════════════════════════════

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.colorScheme,
  });

  final IconData icon;
  final String value;
  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  height: 1,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: colorScheme.outlineVariant.withOpacity(0.5),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Health Indicator - Sleek health status
// ═══════════════════════════════════════════════════════════════

class _HealthIndicator extends StatelessWidget {
  const _HealthIndicator({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    const healthColor = Color(0xFF22C55E); // Green-500

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: healthColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.verified_rounded,
              size: 16,
              color: healthColor,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    'عالی',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: healthColor,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: healthColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              Text(
                'سلامت',
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Recent Tag - Minimal recent item chip
// ═══════════════════════════════════════════════════════════════

class _RecentTag extends StatelessWidget {
  const _RecentTag({required this.entry, required this.colorScheme});

  final PasswordEntry entry;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.public_rounded,
              size: 12,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            entry.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
