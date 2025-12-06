import 'package:flutter/material.dart';

class SetupHeader extends StatelessWidget {
  const SetupHeader({super.key, required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.security,
            color: Colors.white,
            size: 28,
          ),
        ),
        Text(
          'راه‌اندازی امنیتی',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Chip(
          backgroundColor: Colors.white.withOpacity(0.18),
          label: Text(
            'مرحله ۱ از ۱',
            style: textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
