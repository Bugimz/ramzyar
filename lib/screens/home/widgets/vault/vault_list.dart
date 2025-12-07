import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/password_controller.dart';
import 'empty_state.dart';
import 'password_card.dart';

class VaultList extends StatelessWidget {
  const VaultList({super.key, required this.controller});

  final PasswordController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final items = controller.filteredEntries;

      if (items.isEmpty) return const EmptyState();

      return LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 1000
              ? 3
              : constraints.maxWidth > 700
                  ? 2
                  : 1;
          const spacing = 12.0;
          final cardWidth =
              (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
                  crossAxisCount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.key_rounded, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'رمزهای شما',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${items.length} مورد',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: items
                    .map(
                      (item) => SizedBox(
                        width:
                            crossAxisCount == 1 ? constraints.maxWidth : cardWidth,
                        child: PasswordCard(
                          entry: item,
                          onDelete: () => controller.deleteEntry(item.id!),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      );
    });
  }
}
