import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/lock_controller.dart';

class LockForm extends GetView<LockController> {
  const LockForm({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = controller.auth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller.pinController,
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
          onSubmitted: (_) => controller.submitPin(),
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
            onPressed: controller.submitPin,
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
                  onPressed: auth.biometricEnabled.value ? controller.authenticateBiometric : null,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('ورود با بیومتریک'),
                ),
              ),
            )),
      ],
    );
  }
}
