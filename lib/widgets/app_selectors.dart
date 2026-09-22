import 'package:flutter/material.dart';
import '../core/constants.dart';

class GenderPill extends StatelessWidget {
  final String gender;
  final bool selected;
  final VoidCallback onTap;
  final Map<String, String> genderIcons = {
    'male': '♂️',
    'female': '♀️',
  };

  GenderPill({
    Key? key,
    required this.gender,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.offWhite : AppColors.white,
            border: Border.all(
              color: selected ? AppColors.navy : AppColors.gray100,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                genderIcons[gender] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: selected ? AppColors.navy : AppColors.gray300,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                gender[0].toUpperCase() + gender.substring(1),
                style: TextStyle(
                  fontSize: AppTypography.fontSize_sm,
                  fontWeight: FontWeight.w500,
                  color: selected ? AppColors.navy : AppColors.gray700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomTypeButton extends StatelessWidget {
  final String label;
  final int seats;
  final bool selected;
  final VoidCallback onTap;
  final Map<int, String> icons = {
    1: '👤',
    2: '👥',
    3: '👨‍👩‍👧',
    4: '👨‍👩‍👧‍👦',
  };

  RoomTypeButton({
    Key? key,
    required this.label,
    required this.seats,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.offWhite : AppColors.white,
            border: Border.all(
              color: selected ? AppColors.navy : AppColors.gray100,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.fontSize_sm,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.navy : AppColors.gray700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AmenityCheckbox extends StatelessWidget {
  final String label;
  final String amenity;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  const AmenityCheckbox({
    Key? key,
    required this.label,
    required this.amenity,
    required this.icon,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space3,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.greenBg : AppColors.white,
          border: Border.all(
            color: selected ? AppColors.green : AppColors.gray100,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppTypography.fontSize_sm,
                  fontWeight: FontWeight.w500,
                  color: selected ? AppColors.greenDark : AppColors.gray700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: AppColors.green,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

class BudgetSlider extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const BudgetSlider({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<BudgetSlider> createState() => _BudgetSliderState();
}

class _BudgetSliderState extends State<BudgetSlider> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.space2,
          ),
          child: Column(
            children: [
              Text(
                'PKR ${_currentValue.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_xl,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: AppSpacing.space2),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    elevation: 4,
                    enabledThumbRadius: 11,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                ),
                child: Slider(
                  value: _currentValue.toDouble(),
                  min: widget.min.toDouble(),
                  max: widget.max.toDouble(),
                  divisions: (widget.max - widget.min) ~/ 1000,
                  activeColor: AppColors.navy,
                  inactiveColor: AppColors.gray100,
                  thumbColor: AppColors.navy,
                  onChanged: (value) {
                    setState(() {
                      _currentValue = value.toInt();
                    });
                    widget.onChanged(_currentValue);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PKR ${widget.min.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: const TextStyle(
                fontSize: AppTypography.fontSize_xs,
                color: AppColors.gray500,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            Text(
              'PKR ${widget.max.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: const TextStyle(
                fontSize: AppTypography.fontSize_xs,
                color: AppColors.gray500,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OTPInput extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;
  final String initialValue;

  const OTPInput({
    Key? key,
    this.length = 6,
    required this.onChanged,
    this.initialValue = '',
  }) : super(key: key);

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.length, (i) {
      final controller = TextEditingController();
      if (i < widget.initialValue.length) {
        controller.text = widget.initialValue[i];
      }
      return controller;
    });
    focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1) {
      if (index < widget.length - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
      controllers[index - 1].clear();
    }

    final otp = controllers.map((c) => c.text).join();
    widget.onChanged(otp);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.length,
          (index) => Container(
            width: 45,
            height: 58,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              border: Border.all(
                color: controllers[index].text.isEmpty
                    ? AppColors.gray200
                    : AppColors.green,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
              color: controllers[index].text.isEmpty
                  ? AppColors.white
                  : AppColors.greenBg,
            ),
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: AppTypography.fontSize_xl,
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
                fontFamily: AppTypography.fontFamily,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counter: SizedBox.shrink(),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => _onChanged(index, value),
            ),
          ),
        ),
      ),
    );
  }
}
