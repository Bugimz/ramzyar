import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../controllers/generator_controller.dart';

class PasswordDisplay extends GetView<GeneratorController> {
  const PasswordDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                )
              : null,
          color: hasPassword ? null : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasPassword
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.outlineVariant,
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
                if (hasPassword) ...[
                  const SizedBox(width: 12),
                  _CopyButton(text: text, colorScheme: colorScheme),
                ],
              ],
            ),
            if (hasPassword) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
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

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.text, required this.colorScheme});

  final String text;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: text));
          Get.snackbar('کپی شد', 'رمز در کلیپ‌بورد ذخیره شد');
        },
        icon: Icon(Icons.copy_rounded, color: colorScheme.primary),
        tooltip: 'کپی',
      ),
    );
  }
}
