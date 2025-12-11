import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/lock_controller.dart';

class LockForm extends GetView<LockController> {
  const LockForm({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = controller.auth;

    return Column(
      children: [
        // 🔷 PIN Input
        _PinInput(
          controller: controller.pinController,
          onSubmitted: (_) => controller.submitPin(),
        ),

        // 🔷 Error Message
        Obx(() {
          final error = auth.errorMessage.value;
          if (error.isEmpty) return const SizedBox(height: 16);
          return _ErrorBox(message: error);
        }),

        // 🔷 Submit Button
        _SubmitButton(onPressed: controller.submitPin),

        // 🔷 Biometric Button (فقط اگه در دسترس و فعال باشه)
        Obx(() {
          if (!auth.biometricAvailable.value || !auth.biometricEnabled.value) {
            return const SizedBox.shrink();
          }
          return _BiometricButton(onPressed: controller.authenticateBiometric);
        }),

        // 🔷 Biometric Toggle (فقط اگه در دسترس باشه ولی فعال نباشه)
        Obx(() {
          if (!auth.biometricAvailable.value || auth.biometricEnabled.value) {
            return const SizedBox.shrink();
          }
          return _BiometricToggle(onToggle: () => auth.toggleBiometrics(true));
        }),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 PIN Input
// ═══════════════════════════════════════════════════════════════

class _PinInput extends StatefulWidget {
  const _PinInput({required this.controller, this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  @override
  State<_PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<_PinInput> {
  bool _obscure = true;
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: _obscure,
        keyboardType: TextInputType.number,
        maxLength: 4,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 16,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: '••••',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.25),
            fontSize: 28,
            letterSpacing: 16,
          ),
          counterText: '',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(
              _obscure
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: Colors.white.withOpacity(0.4),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Error Box
// ═══════════════════════════════════════════════════════════════

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Submit Button
// ═══════════════════════════════════════════════════════════════

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_open_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'ورود',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Biometric Button (وقتی فعاله)
// ═══════════════════════════════════════════════════════════════

class _BiometricButton extends StatelessWidget {
  const _BiometricButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withOpacity(0.3)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.fingerprint_rounded, size: 22),
          label: const Text(
            'ورود با اثر انگشت',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🔷 Biometric Toggle (وقتی در دسترسه ولی فعال نیست)
// ═══════════════════════════════════════════════════════════════

class _BiometricToggle extends StatelessWidget {
  const _BiometricToggle({required this.onToggle});

  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fingerprint_rounded,
                size: 18,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(width: 8),
              Text(
                'فعال‌سازی ورود با اثر انگشت',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: Colors.white.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
