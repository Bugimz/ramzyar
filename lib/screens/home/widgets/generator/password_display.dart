import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/generator_controller.dart';
import '../common/action_button.dart';

class PasswordDisplay extends StatelessWidget {
  const PasswordDisplay({
    super.key,
    required this.controller,
    required this.colorScheme,
    required this.textTheme,
  });

  final GeneratorController controller;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final text = controller.generated.value;
      final hasPassword = text.isNotEmpty;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: hasPassword
              ? LinearGradient(
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: hasPassword ? null : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasPassword
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    text.isEmpty ? 'رمز شما اینجا نمایش داده می‌شود...' : text,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: text.length > 24 ? 18 : 22,
                      color: text.isEmpty
                          ? Colors.grey
                          : colorScheme.onPrimaryContainer,
                      letterSpacing: text.isEmpty ? 0 : 1.2,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                if (hasPassword)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: CopyButton(onCopy: controller.copyToClipboard),
                  ),
              ],
            ),
            if (hasPassword) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: colorScheme.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'رمز قوی و امن تولید شد',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
