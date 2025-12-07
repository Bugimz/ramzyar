import 'package:flutter/material.dart';

enum ActionButtonSize { small, medium, large }
enum ActionButtonVariant { filled, tonal, outlined, ghost }

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = ActionButtonSize.medium,
    this.variant = ActionButtonVariant.filled,
    this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final ActionButtonSize size;
  final ActionButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final double iconSize;
    final double padding;

    switch (size) {
      case ActionButtonSize.small:
        iconSize = 16;
        padding = 6;
      case ActionButtonSize.medium:
        iconSize = 20;
        padding = 10;
      case ActionButtonSize.large:
        iconSize = 24;
        padding = 14;
    }

    final Color backgroundColor;
    final Color iconColor;

    switch (variant) {
      case ActionButtonVariant.filled:
        backgroundColor = colorScheme.primary;
        iconColor = colorScheme.onPrimary;
      case ActionButtonVariant.tonal:
        backgroundColor = colorScheme.primaryContainer;
        iconColor = colorScheme.onPrimaryContainer;
      case ActionButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        iconColor = colorScheme.primary;
      case ActionButtonVariant.ghost:
        backgroundColor = colorScheme.surfaceVariant.withOpacity(0.5);
        iconColor = colorScheme.onSurfaceVariant;
    }

    Widget child = isLoading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: iconColor,
            ),
          )
        : Icon(icon, size: iconSize, color: iconColor);

    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: variant == ActionButtonVariant.outlined
                ? Border.all(color: colorScheme.primary.withOpacity(0.5))
                : null,
          ),
          child: child,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

class SmallIconButton extends StatelessWidget {
  const SmallIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: color ?? colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

class CopyButton extends StatefulWidget {
  const CopyButton({
    super.key,
    required this.onCopy,
    this.size = 18,
  });

  final VoidCallback onCopy;
  final double size;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;

  void _handleCopy() {
    widget.onCopy();
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleCopy,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _copied ? Icons.check_rounded : Icons.copy_rounded,
              key: ValueKey(_copied),
              size: widget.size,
              color: _copied ? Colors.green : colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
