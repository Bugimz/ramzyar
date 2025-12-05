import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/password_controller.dart';
import '../../lock_screen.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    super.key,
    required this.auth,
    required this.controller,
    this.isWide = false,
  });

  final AuthController auth;
  final PasswordController controller;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final total = controller.entries.length;
    final recent = controller.entries.take(3).toList();

    return LayoutBuilder(builder: (context, constraints) {
      final isStacked = constraints.maxWidth < 560;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isWide ? 22 : 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 14, offset: Offset(0, 8)),
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
                        child: IconButton(
                          tooltip: 'قفل کردن',
                          onPressed: () {
                            auth.lockApp();
                            Get.offAll(() => const LockScreen());
                          },
                          icon: const Icon(Icons.lock_outline),
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
                        tooltip: 'قفل کردن',
                        onPressed: () {
                          auth.lockApp();
                          Get.offAll(() => const LockScreen());
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
                        color: const Color(0xfff8f3e8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.health_and_safety_outlined,
                              color: Color(0xfff59e0b), size: 18),
                          SizedBox(width: 6),
                          Text('سلامت خوب', style: TextStyle(color: Color(0xffd97706))),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            if (recent.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('خیراً استفاده شده',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('سلام، خوش برگشتی',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        SizedBox(height: 4),
        Text('همه رمزهایت امن و منظم هستند', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffe8ecff),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.shield_outlined, color: Color(0xff4c63f6)),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 10 : 12, vertical: dense ? 8 : 10),
      decoration: BoxDecoration(
        color: const Color(0xffe8ecff),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: dense ? 14 : 16)),
          const Text(label, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
