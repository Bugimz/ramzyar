import 'package:flutter/material.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../models/password_entry.dart';
import 'header_actions.dart';
import 'header_stats.dart';
import 'recent_tags.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    super.key,
    required this.auth,
    required this.total,
    required this.recent,
    this.isWide = false,
  });

  final AuthController auth;
  final int total;
  final List<PasswordEntry> recent;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(isDark ? 0.3 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(isWide ? 20 : 16),
                child: Row(
                  children: [
                    _AvatarBadge(colorScheme: colorScheme),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سلام، خوش برگشتی 👋',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'رمزهایت امن هستند',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const HeaderActions(),
                  ],
                ),
              ),
              HeaderStats(total: total, isWide: isWide),
              if (recent.isNotEmpty)
                RecentTags(
                  entries: recent,
                  isWide: isWide,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(Icons.shield_rounded, color: colorScheme.onPrimary, size: 24),
    );
  }
}
