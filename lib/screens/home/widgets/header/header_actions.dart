import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../routes/app_routes.dart';
import '../settings/security_sheet.dart';

class HeaderActions extends StatelessWidget {
  const HeaderActions({super.key});

  AuthController get auth => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionButton(
            icon: Icons.tune_rounded,
            tooltip: 'تنظیمات',
            onTap: () => _showSettings(context),
          ),
          Container(
            width: 1,
            height: 20,
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
          _ActionButton(
            icon: Icons.lock_rounded,
            tooltip: 'قفل',
            onTap: _lockApp,
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    Get.bottomSheet(
      const SecuritySheet(),
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }

  void _lockApp() {
    auth.lockApp();
    Get.offAllNamed(Routes.lock);
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
