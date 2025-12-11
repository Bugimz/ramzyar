import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// دیالوگ پیشنهاد ذخیره رمز از کلیپ‌بورد
///
/// وقتی کاربر متنی شامل username:password کپی می‌کند،
/// این دیالوگ نمایش داده می‌شود.
class ClipboardPromptDialog extends StatelessWidget {
  const ClipboardPromptDialog({
    super.key,
    required this.content,
    required this.onSave,
    required this.onCancel,
  });

  final String content;
  final void Function(String username, String password) onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final parts = content.split(':');
    final username = parts.first.trim();
    final password = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('ذخیره رمز جدید؟'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'به نظر می‌رسد نام کاربری و رمز عبور جدیدی وارد کرده‌اید.',
          ),
          const SizedBox(height: 12),
          _InfoTile(label: 'نام کاربری', value: username),
          const SizedBox(height: 8),
          _InfoTile(
            label: 'رمز عبور',
            value: '•' * password.length.clamp(4, 12),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('خیر')),
        ElevatedButton(
          onPressed: () {
            onSave(username, password);
            Get.back();
          },
          child: const Text('بله، ذخیره کن'),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
