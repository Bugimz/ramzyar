import 'package:flutter/material.dart';

class HintBadge extends StatelessWidget {
  const HintBadge({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Chip(
      backgroundColor: colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      avatar: Icon(icon, color: colorScheme.onSecondaryContainer, size: 18),
      label: Text(
        text,
        style: TextStyle(color: colorScheme.onSecondaryContainer),
      ),
    );
  }
}
