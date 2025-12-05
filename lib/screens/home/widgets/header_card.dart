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

    return LayoutBuilder(builder: (context, constraints) {
      final isStacked = constraints.maxWidth < 560;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isWide ? 22 : 18),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.35 : 0.08),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isStacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HeaderBadge(),
                      const SizedBox(height: 12),
                      const _HeaderTitles(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'تنظیمات امنیتی',
                              onPressed: () {
                                Get.bottomSheet(
                                  const SecuritySheet(),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.vertical(top: Radius.circular(22)),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.shield_moon_outlined),
                            ),
                            IconButton(
                              tooltip: 'قفل کردن',
                              onPressed: () {
                                auth.lockApp();
                                Get.offAllNamed(Routes.lock);
                              },
                              icon: const Icon(Icons.lock_outline),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HeaderBadge(),
                      const SizedBox(width: 12),
                      const Expanded(child: _HeaderTitles()),
                      IconButton(
                        tooltip: 'تنظیمات امنیتی',
                        onPressed: () {
                          Get.bottomSheet(
                            const SecuritySheet(),
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(22)),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shield_moon_outlined),
                      ),
                      IconButton(
                        tooltip: 'قفل کردن',
                        onPressed: () {
                          auth.lockApp();
                          Get.offAllNamed(Routes.lock);
                        },
                        icon: const Icon(Icons.lock_outline),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDense = constraints.maxWidth < 420;
                return Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatPill(label: 'تعداد والت', value: '1', dense: isDense),
                    StatPill(label: 'تعداد رمز', value: '$total', dense: isDense),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.health_and_safety_outlined, size: 18),
                          SizedBox(width: 6),
                          Text('سلامت خوب'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            if (recent.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('خیراً استفاده شده',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: recent
                    .map(
                      (e) => Chip(
                        label: Text(e.title),
                        backgroundColor: const Color(0xfff3f5ff),
                        avatar: const Icon(Icons.language, color: Color(0xff4c63f6)),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _HeaderTitles extends StatelessWidget {
  const _HeaderTitles();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('سلام، خوش برگشتی',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('همه رمزهایت امن و منظم هستند', style: textTheme.bodyMedium?.copyWith(color: Colors.grey)),
      ],
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.shield_outlined, color: colorScheme.onPrimaryContainer),
    );
  }
}

class StatPill extends StatelessWidget {
  const StatPill({super.key, required this.label, required this.value, this.dense = false});
  final String label;
  final String value;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 10 : 12, vertical: dense ? 8 : 10),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: dense ? 14 : 16,
                color: colorScheme.onSecondaryContainer,
              )),
          Text(label,
              style: TextStyle(
                color: colorScheme.onSecondaryContainer.withOpacity(0.8),
              )),
        ],
      ),
    );
  }
}
