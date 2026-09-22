import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonTap;
  final Color? iconColor;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonTap,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.navy).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor ?? AppColors.navy,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space5),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_lg,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: AppTypography.fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.space2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: AppTypography.fontSize_sm,
                color: AppColors.gray500,
                fontFamily: AppTypography.fontFamily,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (buttonText != null && onButtonTap != null) ...[
            const SizedBox(height: AppSpacing.space5),
            GestureDetector(
              onTap: onButtonTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space5,
                  vertical: AppSpacing.space3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FontAwesomeIcons.plus,
                      color: AppColors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      buttonText!,
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
