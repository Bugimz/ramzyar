import 'package:flutter/material.dart';

class PinField extends StatelessWidget {
  const PinField({
    super.key,
    required this.controller,
    required this.label,
    required this.showText,
    required this.onToggleVisibility,
  });

  final TextEditingController controller;
  final String label;
  final bool showText;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      obscureText: !showText,
      keyboardType: TextInputType.number,
      maxLength: 4,
      decoration: InputDecoration(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(showText ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggleVisibility,
        ),
        labelText: label,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
      ),
    );
  }
}
