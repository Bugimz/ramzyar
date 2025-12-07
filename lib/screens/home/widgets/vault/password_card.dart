import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../models/password_entry.dart';
import '../../../../routes/app_routes.dart';
import 'info_row.dart';

class PasswordCard extends StatelessWidget {
  const PasswordCard({super.key, required this.entry, required this.onDelete});

  final PasswordEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(Routes.addEditPassword, arguments: entry),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(entry: entry, onDelete: onDelete),
                const SizedBox(height: 14),
                InfoRow(
                  icon: Icons.person_outline_rounded,
                  label: 'کاربری',
                  value: entry.username,
                  onCopy: () => _copy(entry.username, 'نام کاربری'),
                ),
                const SizedBox(height: 10),
                InfoRow(
                  icon: Icons.key_rounded,
                  label: 'رمز',
                  value: '•' * entry.password.length.clamp(6, 12),
                  onCopy: () => _copy(entry.password, 'رمز عبور'),
                  isPassword: true,
                ),
                if (entry.notes?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  _Notes(notes: entry.notes!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _copy(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'کپی شد',
      '$label در کلیپ‌بورد قرار گرفت',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.entry, required this.onDelete});

  final PasswordEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer,
                colorScheme.secondaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.public_rounded,
            color: colorScheme.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (entry.website?.isNotEmpty ?? false)
                Text(
                  entry.website!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        _MenuButton(entry: entry, onDelete: onDelete),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.entry, required this.onDelete});

  final PasswordEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          Get.toNamed(Routes.addEditPassword, arguments: entry);
        } else if (value == 'delete') {
          _showDeleteDialog(context);
        }
      },
      icon: Icon(Icons.more_vert_rounded, color: colorScheme.onSurfaceVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_rounded, size: 18),
              SizedBox(width: 10),
              Text('ویرایش'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_rounded, size: 18, color: Colors.redAccent),
              SizedBox(width: 10),
              Text('حذف', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('حذف رمز'),
        content: Text('آیا از حذف "${entry.title}" مطمئن هستید؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'انصراف',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

class _Notes extends StatelessWidget {
  const _Notes({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        notes,
        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
