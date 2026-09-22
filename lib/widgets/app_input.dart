import 'package:flutter/material.dart';
import '../core/constants.dart';

class AppInputField extends StatefulWidget {
  final String? label;
  final String placeholder;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final int maxLines;
  final int minLines;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const AppInputField({
    Key? key,
    this.label,
    required this.placeholder,
    this.controller,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines = 1,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              if (widget.prefixIcon != null)
                Icon(widget.prefixIcon, color: AppColors.navy, size: 16),
              if (widget.prefixIcon != null) const SizedBox(width: 8),
              Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_sm,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
        ],
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          onChanged: widget.onChanged,
          style: const TextStyle(
            fontSize: AppTypography.fontSize_base,
            color: AppColors.gray900,
            fontFamily: AppTypography.fontFamily,
          ),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: const TextStyle(
              color: AppColors.gray300,
              fontFamily: AppTypography.fontFamily,
            ),
            filled: true,
            fillColor: widget.enabled ? AppColors.white : AppColors.gray50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space4,
              vertical: AppSpacing.space3,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.gray100,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.gray100,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.navyLighter,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppDropdownField extends StatefulWidget {
  final String? label;
  final IconData? prefixIcon;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onChanged;

  const AppDropdownField({
    Key? key,
    this.label,
    this.prefixIcon,
    required this.items,
    this.selectedItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AppDropdownField> createState() => _AppDropdownFieldState();
}

class _AppDropdownFieldState extends State<AppDropdownField> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedItem ?? widget.items[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              if (widget.prefixIcon != null)
                Icon(widget.prefixIcon, color: AppColors.navy, size: 16),
              if (widget.prefixIcon != null) const SizedBox(width: 8),
              Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_sm,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
        ],
        DropdownButtonFormField<String>(
          initialValue: _selectedValue,
          items: widget.items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        color: AppColors.gray900,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedValue = value);
              widget.onChanged(value);
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space4,
              vertical: AppSpacing.space3,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.gray100,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.gray100,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.navyLighter,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
