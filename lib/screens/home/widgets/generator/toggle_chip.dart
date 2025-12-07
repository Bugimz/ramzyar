import 'package:flutter/material.dart';

class ToggleChip extends StatelessWidget {
  const ToggleChip({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: value
              ? LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                )
              : null,
          color: value ? null : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: value ? null : Border.all(color: colorScheme.outlineVariant),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_circle_rounded : icon,
              color: value ? colorScheme.onPrimary : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: value ? colorScheme.onPrimary : Colors.grey.shade700,
                fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
