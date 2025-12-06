import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/setup_pin_controller.dart';
import 'widgets/hint_badge.dart';
import 'widgets/pin_field.dart';
import 'widgets/setup_header.dart';

class SetupPinScreen extends GetView<SetupPinController> {
  const SetupPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final scaffold = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffold,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 640;
            final horizontal = isWide ? 48.0 : 22.0;
            final cardPadding = isWide ? 32.0 : 20.0;

            return Stack(
              children: [
                Positioned(
                  top: -40,
                  right: -120,
                  left: -120,
                  child: Container(
                    height: 280,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(48),
                        bottomRight: Radius.circular(48),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(horizontal, 28, horizontal, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SetupHeader(textTheme: textTheme),
                          const SizedBox(height: 28),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(cardPadding),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.08),
                                    blurRadius: 16,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'انتخاب پین ۴ رقمی',
                                    style: textTheme.titleMedium?.copyWith(
                                        fontSize: 20, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'این پین برای ورود سریع و رمزگذاری داده‌های شما استفاده می‌شود. '
                                    'بعداً می‌توانید ورود بیومتریک را هم فعال کنید.',
                                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 24),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: const [
                                      HintBadge(icon: Icons.timer, text: 'قفل خودکار قابل تنظیم'),
                                      HintBadge(icon: Icons.phonelink_lock, text: 'جلوگیری از اسکرین‌شات'),
                                    ],
                                  ),
                                  const SizedBox(height: 28),
                                  Obx(() => PinField(
                                        controller: controller.pinController,
                                        label: 'رمز عبور',
                                        showText: controller.showPin.value,
                                        onToggleVisibility: controller.showPin.toggle,
                                      )),
                                  const SizedBox(height: 14),
                                  Obx(() => PinField(
                                        controller: controller.confirmController,
                                        label: 'تکرار رمز عبور',
                                        showText: controller.showConfirm.value,
                                        onToggleVisibility: controller.showConfirm.toggle,
                                      )),
                                  const SizedBox(height: 10),
                                  Obx(() {
                                    final error = controller.error.value;
                                    if (error == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        error,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    );
                                  }),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.info_outline, color: colorScheme.primary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'پین شما فقط روی این دستگاه و به صورت رمزگذاری‌شده نگهداری می‌شود.',
                                          style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Obx(() {
                                      final saving = controller.saving.value;
                                      return ElevatedButton.icon(
                                        onPressed: saving ? null : controller.savePin,
                                        icon: saving
                                            ? const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Icon(Icons.check_circle_outline),
                                        label: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Text(
                                            saving ? 'در حال ذخیره...' : 'تأیید و ادامه',
                                            style:
                                                textTheme.titleSmall?.copyWith(color: Colors.white),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: colorScheme.primary,
                                          foregroundColor: colorScheme.onPrimary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
