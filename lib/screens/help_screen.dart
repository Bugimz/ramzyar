import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'help/help_content.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('راهنمای استفاده'),
        actions: [
          IconButton(
            tooltip: 'بازگشت',
            onPressed: Get.back,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          final isMedium = constraints.maxWidth > 640;
          final crossAxisCount = isWide
              ? 3
              : isMedium
                  ? 2
                  : 1;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 32 : 20,
              vertical: isWide ? 24 : 16,
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isWide
                    ? 1.2
                    : isMedium
                        ? 1.1
                        : 1.05,
              ),
              itemCount: helpSections.length,
              itemBuilder: (context, index) {
                final section = helpSections[index];
                return _HelpCard(section: section, textTheme: textTheme);
              },
            ),
          );
        },
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.section, required this.textTheme});

  final HelpSection section;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
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
