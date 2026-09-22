import 'package:flutter/material.dart';
import '../core/constants.dart';

class ToastHelper {
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showToast(
      context,
      message: message,
      backgroundColor: AppColors.green,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showToast(
      context,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_outlined,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showToast(
      context,
      message: message,
      backgroundColor: AppColors.navy,
      icon: Icons.info_outlined,
      duration: duration,
    );
  }

  static void _showToast(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 30,
        left: 20,
        right: 20,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, (1 - value) * 100),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
