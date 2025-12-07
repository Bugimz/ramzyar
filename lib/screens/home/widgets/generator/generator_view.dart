import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/generator_controller.dart';
import 'password_display.dart';
import 'length_slider.dart';
import 'toggle_chip.dart';
import 'security_tip.dart';

class GeneratorView extends GetView<GeneratorController> {
  const GeneratorView({super.key, required this.maxWidth});

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isWide = maxWidth > 900;
    final isTablet = maxWidth > 700;
    final horizontalPadding = isWide
        ? 32.0
        : isTablet
            ? 24.0
            : 16.0;

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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
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
                            ),
                            borderRadius: BorderRadius.circular(16),
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

                    // Password Display
                    const PasswordDisplay(),
                    const SizedBox(height: 28),

                    // Length Slider
                    const LengthSlider(),
                    const SizedBox(height: 24),

                    // Options
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
                          ),
                        ),
                        Obx(
                          () => ToggleChip(
                            label: 'نمادها (!@#)',
                            icon: Icons.tag_rounded,
                            value: controller.symbols.value,
                            onChanged: controller.toggleSymbols,
                          ),
                        ),
                        Obx(
                          () => ToggleChip(
                            label: 'حروف کوچک (a-z)',
                            icon: Icons.text_fields_rounded,
                            value: controller.lower.value,
                            onChanged: controller.toggleLower,
                          ),
                        ),
                        Obx(
                          () => ToggleChip(
                            label: 'حروف بزرگ (A-Z)',
                            icon: Icons.title_rounded,
                            value: controller.upper.value,
                            onChanged: controller.toggleUpper,
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
              const SecurityTip(),
            ],
          ),
        ),
      ),
    );
  }
}
