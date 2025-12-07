import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramzyar/screens/home/widgets/settings/setting_tiles.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../controllers/theme_controller.dart';
import '../../../../routes/app_routes.dart';

class SecuritySheet extends StatelessWidget {
  const SecuritySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final theme = Get.find<ThemeController>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.settings_rounded,
                    color: colorScheme.onPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تنظیمات',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'امنیت و ظاهر برنامه',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Auto Lock Options
            LockOptionsSection(auth: auth),
            const SizedBox(height: 16),

            // Toggle Tiles
            Obx(
              () => ToggleTile(
                icon: Icons.dark_mode_outlined,
                title: 'حالت تاریک',
                subtitle: 'تم شب برای کاهش نور',
                value: theme.themeMode.value == ThemeMode.dark,
                onChanged: theme.toggleDark,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => ToggleTile(
                icon: Icons.screenshot_monitor_outlined,
                title: 'محافظت از صفحه',
                subtitle: 'جلوگیری از اسکرین‌شات',
                value: auth.screenSecureEnabled.value,
                onChanged: auth.toggleScreenSecure,
              ),
            ),

            const SizedBox(height: 16),
            Divider(color: colorScheme.outlineVariant.withOpacity(0.5)),
            const SizedBox(height: 8),

            // Action Tiles
            ActionTile(
              icon: Icons.help_outline_rounded,
              title: 'راهنما',
              onTap: () {
                Get.back();
                Get.toNamed(Routes.help);
              },
            ),
            ActionTile(
              icon: Icons.lock_outline_rounded,
              title: 'قفل برنامه',
              isDestructive: true,
              onTap: () async {
                await auth.lockApp();
                Get.back();
                Get.offAllNamed(Routes.lock);
              },
            ),
          ],
        ),
      ),
    );
  }
}
