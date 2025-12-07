import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/generator_controller.dart';

class LengthSlider extends GetView<GeneratorController> {
  const LengthSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
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
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                    borderRadius: BorderRadius.circular(12),
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
                inactiveTrackColor: colorScheme.primary.withOpacity(0.2),
                thumbColor: colorScheme.primary,
                overlayColor: colorScheme.primary.withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
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
    );
  }
}
