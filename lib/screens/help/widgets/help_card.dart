import 'package:flutter/material.dart';

import '../help_content.dart';

class HelpCard extends StatelessWidget {
  const HelpCard({super.key, required this.section, required this.textTheme});

  final HelpSection section;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(section.icon, color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 12),
          Text(
            section.title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            section.body,
            style: textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
          const Spacer(),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: section.chips
                .map(
                  (c) => Chip(
                    label: Text(c),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: colorScheme.secondaryContainer,
                    labelStyle:
                        textTheme.labelMedium?.copyWith(color: colorScheme.onSecondaryContainer),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
