import 'package:flutter/material.dart';

class PasswordSecretField extends StatelessWidget {
  const PasswordSecretField({
    super.key,
    required this.controller,
    required this.showPassword,
    required this.onToggle,
    required this.onGenerate,
  });

  final TextEditingController controller;
  final bool showPassword;
  final VoidCallback onToggle;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: !showPassword,
        maxLines: 1,
        autofillHints: const [AutofillHints.password],
        decoration: InputDecoration(
          labelText: 'رمز عبور',
          hintText: 'یک رمز قوی وارد کنید یا بسازید',
          prefixIcon: const Icon(Icons.lock_outline),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: showPassword ? 'مخفی کردن' : 'نمایش',
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onToggle,
              ),
              IconButton(
                tooltip: 'تولید خودکار',
                icon: const Icon(Icons.auto_fix_high_outlined),
                onPressed: onGenerate,
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
      ),
    );
  }
}
