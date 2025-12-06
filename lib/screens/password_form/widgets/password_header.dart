import 'package:flutter/material.dart';

class PasswordHeader extends StatelessWidget {
  const PasswordHeader({
    super.key,
    required this.isEditing,
    required this.textTheme,
    required this.colorScheme,
  });

  final bool isEditing;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.vpn_key, color: colorScheme.onPrimaryContainer),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'ویرایش ورودی' : 'افزودن ورودی جدید',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'اطلاعات ورود را ذخیره کنید تا در پیشنهادهای خودکار نمایش داده شود.',
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        Chip(
          label: Text(isEditing ? 'در حال ویرایش' : 'جدید'),
          backgroundColor: colorScheme.secondaryContainer,
          labelStyle: textTheme.labelLarge?.copyWith(color: colorScheme.onSecondaryContainer),
        )
      ],
    );
  }
}
