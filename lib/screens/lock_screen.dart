import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();
  final auth = Get.find<AuthController>();

  Future<void> _submit() async {
    await auth.validatePin(_pinController.text.trim());
  }

  Future<void> _biometric() async {
    await auth.authenticateWithBiometrics();
  }

  @override
  Widget build(BuildContext context) {
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
                      TextField(
                        controller: _pinController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          labelText: 'رمز عبور',
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 12),
                      Obx(() => Text(
                            auth.errorMessage.value,
                            style: const TextStyle(color: Colors.red),
                          )),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xff5169f6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('ورود'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() => Visibility(
                            visible: auth.biometricAvailable.value,
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed:
                                    auth.biometricEnabled.value ? _biometric : null,
                                icon: const Icon(Icons.fingerprint),
                                label: const Text('ورود با بیومتریک'),
                              ),
                            ),
                          )),
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
