import 'package:flutter/material.dart';
import '../core/constants.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final String variant; // 'primary', 'outline', 'outline-green', 'danger-outline'
  final double? width;
  final double? height;
  final bool enabled;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = 'primary',
    this.width,
    this.height,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  Color _getBackgroundColor() {
    if (!widget.enabled) {
      return AppColors.gray200;
    }
    switch (widget.variant) {
      case 'outline':
        return Colors.transparent;
      case 'outline-green':
        return Colors.transparent;
      case 'danger-outline':
        return Colors.transparent;
      default:
        return AppColors.green;
    }
  }

  Color _getTextColor() {
    switch (widget.variant) {
      case 'outline':
        return AppColors.navy;
      case 'outline-green':
        return AppColors.green;
      case 'danger-outline':
        return AppColors.error;
      default:
        return AppColors.white;
    }
  }

  Border? _getBorder() {
    switch (widget.variant) {
      case 'outline':
        return Border.all(color: AppColors.gray200, width: 2);
      case 'outline-green':
        return Border.all(color: AppColors.green, width: 2);
      case 'danger-outline':
        return Border.all(color: AppColors.error, width: 2);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.enabled && !widget.isLoading) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      onTap: widget.enabled && !widget.isLoading ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppDurations.fast,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 52,
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            border: _getBorder(),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: widget.variant == 'primary' && !_isPressed
                ? [
                    BoxShadow(
                      color: AppColors.green.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.variant == 'primary'
                            ? AppColors.white
                            : _getTextColor(),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: _getTextColor(),
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.space2),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: _getTextColor(),
                          fontSize: AppTypography.fontSize_base,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const SmallButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: AppSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.white, size: 14),
              const SizedBox(width: AppSpacing.space2),
            ],
            Text(
              text,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppTypography.fontSize_sm,
                fontWeight: FontWeight.w600,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Not named IconButton: that would clash with Material's IconButton in any
// file importing both.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const AppIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.color = AppColors.navy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Center(
          child: Icon(icon, color: color, size: 18),
        ),
      ),
    );
  }
}
