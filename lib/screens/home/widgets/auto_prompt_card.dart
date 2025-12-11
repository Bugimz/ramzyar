import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/password_controller.dart';

class AutoPromptCard extends StatelessWidget {
  const AutoPromptCard({
    super.key,
    this.isWide = false,
    required PasswordController controller,
  });

  final bool isWide;

  PasswordController get controller => Get.find<PasswordController>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 20 : 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Obx(() {
        final isEnabled = controller.autoPromptEnabled.value;

        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isEnabled
                    ? LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                      )
                    : null,
                color: isEnabled ? null : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isEnabled
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_outlined,
                color: isEnabled
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ذخیره خودکار',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'پیشنهاد ذخیره رمز هنگام ورود',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 0.9,
              child: Switch.adaptive(
                value: isEnabled,
                activeColor: colorScheme.primary,
                onChanged: controller.setAutoPrompt,
              ),
            ),
          ],
        );
      }),
    );
  }
}
