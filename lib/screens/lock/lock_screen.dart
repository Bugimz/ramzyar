import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/lock_controller.dart';
import 'widgets/lock_form.dart';

class LockScreen extends GetView<LockController> {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = controller.auth;
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fb),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 640;
            final horizontal = isWide ? 40.0 : 24.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'رمزیار',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('برای ورود، رمز عبور خود را وارد کنید یا از اثر انگشت استفاده کنید'),
                      const SizedBox(height: 32),
                      const LockForm(),
                      const Spacer(),
                      Obx(
                        () => SwitchListTile(
                          value: auth.biometricEnabled.value,
                          onChanged: auth.biometricAvailable.value
                              ? (value) => auth.toggleBiometrics(value)
                              : null,
                          title: const Text('فعال‌سازی ورود با اثر انگشت'),
                          subtitle: const Text('نیاز به اجازه بیومتریک در دستگاه دارد'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
