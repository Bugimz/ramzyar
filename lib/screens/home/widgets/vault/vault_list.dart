import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../../../controllers/password_controller.dart';
import '../../../models/password_entry.dart';
import '../../../routes/app_routes.dart';

class VaultList extends StatelessWidget {
  const VaultList({super.key, required this.controller});
  final PasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.filteredEntries;
      if (items.isEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(
            child: Text('رمزی ثبت نشده است. از دکمه + برای افزودن استفاده کنید.'),
          ),
        );
      }

      return LayoutBuilder(builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1000
            ? 3
            : constraints.maxWidth > 700
                ? 2
                : 1;
        final spacing = 12.0;
        final cardWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
            crossAxisCount;
        final itemWidth = crossAxisCount == 1 ? constraints.maxWidth : cardWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('رمزهای شما',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: items
                  .map((item) => SizedBox(
                        width: itemWidth,
                        child: PasswordCard(entry: item, controller: controller),
                      ))
                  .toList(),
            ),
          ],
        );
      });
    });
  }
}

class PasswordCard extends StatelessWidget {
  const PasswordCard({super.key, required this.entry, required this.controller});
  final PasswordEntry entry;
  final PasswordController controller;

  Future<void> _copy(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('کپی شد', '$label در کلیپ‌بورد قرار گرفت', snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xfff3f5ff),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.language, color: Color(0xff4c63f6)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      if (entry.website != null && entry.website!.isNotEmpty)
                        Text(entry.website!, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.toNamed(Routes.addEditPassword, arguments: entry);
                    } else if (value == 'delete') {
                      controller.deleteEntry(entry.id!);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('ویرایش')),
                    PopupMenuItem(value: 'delete', child: Text('حذف')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            InfoRow(
              icon: Icons.person_outline,
              label: 'نام کاربری',
              value: entry.username,
              onCopy: () => _copy(entry.username, 'نام کاربری'),
            ),
            const SizedBox(height: 8),
            InfoRow(
              icon: Icons.lock_outline,
              label: 'رمز',
              value: '*' * (entry.password.length < 12 ? entry.password.length : 12),
              onCopy: () => _copy(entry.password, 'رمز عبور'),
            ),
            if (entry.notes != null && entry.notes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(entry.notes!, style: const TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onCopy,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        IconButton(
          tooltip: 'کپی',
          onPressed: onCopy,
          icon: const Icon(Icons.copy, size: 18),
        ),
      ],
    );
  }
}
