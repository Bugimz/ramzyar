import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../../controllers/generator_controller.dart';

class GeneratorView extends GetView<GeneratorController> {
  const GeneratorView({super.key, required this.maxWidth});
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final isWide = maxWidth > 900;
    final isTablet = maxWidth > 700 && maxWidth <= 900;
    final horizontalPadding = isWide
        ? 32.0
        : isTablet
            ? 24.0
            : 16.0;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          24,
          horizontalPadding,
          120,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              // Main Generator Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with icon and title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.secondary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.password_rounded,
                            color: colorScheme.onPrimary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'سازنده رمز قوی',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'تولید رمزهای امن و تصادفی',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Password Display Box
                    Obx(() {
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
                          color: hasPassword
                              ? null
                              : colorScheme.surfaceVariant,
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
                                    text.isEmpty
                                        ? 'رمز شما اینجا نمایش داده می‌شود...'
                                        : text,
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
                                  _ActionButton(
                                    icon: Icons.copy_rounded,
                                    tooltip: 'کپی',
                                    onPressed: controller.copyToClipboard,
                                    colorScheme: colorScheme,
                                  ),
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
                    }),

                    const SizedBox(height: 28),

                    // Length Slider Section
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.straighten_rounded,
                                    color: colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'طول رمز عبور',
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Obx(
                                () => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.primary,
                                        colorScheme.secondary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${controller.length.value} کاراکتر',
                                    style: textTheme.titleSmall?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: colorScheme.primary,
                                inactiveTrackColor: colorScheme.primary
                                    .withOpacity(0.2),
                                thumbColor: colorScheme.primary,
                                overlayColor: colorScheme.primary.withOpacity(
                                  0.2,
                                ),
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 10,
                                ),
                                trackHeight: 6,
                              ),
                              child: Slider(
                                value: controller.length.value.toDouble(),
                                min: 8,
                                max: 32,
                                divisions: 24,
                                label: '${controller.length.value}',
                                onChanged: controller.updateLength,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Options Section
                    Text(
                      'تنظیمات رمز عبور',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Obx(
                          () => ToggleChip(
                            label: 'اعداد (0-9)',
                            icon: Icons.pin_outlined,
                            value: controller.numbers.value,
                            onChanged: controller.toggleNumbers,
                            colorScheme: colorScheme,
                          ),
                        ),
                        Obx(
                          () => ToggleChip(
                            label: 'نمادها (!@#)',
                            icon: Icons.tag_rounded,
                            value: controller.symbols.value,
                            onChanged: controller.toggleSymbols,
                            colorScheme: colorScheme,
                          ),
                        ),
                        Obx(
                          () => ToggleChip(
                            label: 'حروف کوچک (a-z)',
                            icon: Icons.text_fields_rounded,
                            value: controller.lower.value,
                            onChanged: controller.toggleLower,
                            colorScheme: colorScheme,
                          ),
                        ),
                        Obx(
                          () => ToggleChip(
                            label: 'حروف بزرگ (A-Z)',
                            icon: Icons.title_rounded,
                            value: controller.upper.value,
                            onChanged: controller.toggleUpper,
                            colorScheme: colorScheme,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Generate Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.generate,
                        icon: const Icon(Icons.refresh_rounded, size: 24),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          shadowColor: colorScheme.primary.withOpacity(0.4),
                        ),
                        label: Text(
                          'تولید رمز جدید',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tips Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.secondary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        color: colorScheme.onSecondaryContainer,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نکته امنیتی',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'برای امنیت بیشتر، حداقل از 16 کاراکتر و ترکیب همه گزینه‌ها استفاده کنید.',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleChip extends StatelessWidget {
  const ToggleChip({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.colorScheme,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: value
              ? LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: value ? null : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.outlineVariant,
            width: value ? 0 : 1.5,
          ),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_circle_rounded : icon,
              color: value ? colorScheme.onPrimary : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: value ? colorScheme.onPrimary : Colors.grey.shade700,
                fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.colorScheme,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: colorScheme.primary,
        tooltip: tooltip,
        iconSize: 22,
      ),
    );
  }
}
