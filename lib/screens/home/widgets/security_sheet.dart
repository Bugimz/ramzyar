import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class SecuritySheet extends StatelessWidget {
  const SecuritySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    const lockOptions = [1, 3, 5, 10, 30];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.security_outlined, color: Color(0xff5169f6)),
                const SizedBox(width: 8),
                const Text('تنظیمات امنیتی',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('زمان قفل خودکار', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: lockOptions
                    .map(
                      (m) => ChoiceChip(
                        label: Text('$m دقیقه'),
                        selected: auth.autoLockMinutes.value == m,
                        onSelected: (_) => auth.setAutoLockMinutes(m),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: auth.screenSecureEnabled.value,
                onChanged: (val) => auth.toggleScreenSecure(val),
                title: const Text('محدودیت اسکرین‌شات'),
                subtitle: const Text('جلوگیری از اسکرین‌شات و ضبط صفحه در اپ'),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('خروج دستی'),
              subtitle: const Text('قفل فوری برنامه و بازگشت به صفحه ورود'),
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
