import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/complete_models.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';
import '../utils/toast_helper.dart';

class EditHostelScreen extends StatefulWidget {
  final HostelData hostel;

  const EditHostelScreen({Key? key, required this.hostel}) : super(key: key);

  @override
  State<EditHostelScreen> createState() => _EditHostelScreenState();
}

class _EditHostelScreenState extends State<EditHostelScreen> {
  // Set once the success pop is scheduled, so repeat taps can't pop twice.
  bool _isSubmitting = false;
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;
  late TextEditingController managerNameController;
  late TextEditingController managerPhoneController;

  List<String> selectedAmenities = [];
  int totalCapacity = 0;

  final List<String> amenityOptions = [
    'UPS',
    'Wi-Fi',
    'Mess',
    'Laundry',
    'Security',
    'Garden',
    'AC',
    'Hot Water',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.hostel.name);
    addressController = TextEditingController(text: widget.hostel.address);
    descriptionController = TextEditingController(text: widget.hostel.description);
    managerNameController = TextEditingController(text: widget.hostel.managerName);
    managerPhoneController = TextEditingController(text: widget.hostel.managerPhone);
    selectedAmenities = List.from(widget.hostel.amenities);
    totalCapacity = widget.hostel.totalCapacity;
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    managerNameController.dispose();
    managerPhoneController.dispose();
    super.dispose();
  }

  void saveChanges() {
    if (_isSubmitting) return;
    if (nameController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter hostel name');
      return;
    }
    if (addressController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter address');
      return;
    }
    if (descriptionController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter description');
      return;
    }
    if (selectedAmenities.isEmpty) {
      ToastHelper.showError(context, message: 'Please select at least one amenity');
      return;
    }

    ToastHelper.showSuccess(context, message: 'Hostel details updated successfully!');
    _isSubmitting = true;
    Future.delayed(const Duration(seconds: 2), () {
      // Skip if the user already left, or another screen is now on top.
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Edit Hostel Details'),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(FontAwesomeIcons.chevronLeft, color: AppColors.navy),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Basic Info
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            AppInputField(
              label: 'Hostel Name',
              placeholder: 'Enter hostel name',
              controller: nameController,
              prefixIcon: FontAwesomeIcons.building,
            ),
            const SizedBox(height: AppSpacing.space3),

            AppInputField(
              label: 'Address',
              placeholder: 'Enter full address',
              controller: addressController,
              prefixIcon: FontAwesomeIcons.mapPin,
            ),
            const SizedBox(height: AppSpacing.space3),

            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray200),
              ),
              child: TextField(
                controller: descriptionController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe your hostel features and atmosphere',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppSpacing.space3),
                  counterText: '${descriptionController.text.length}/500',
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Section 2: Manager Info
            const Text(
              'Manager Information',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            AppInputField(
              label: 'Manager Name',
              placeholder: 'Enter manager/warden name',
              controller: managerNameController,
              prefixIcon: FontAwesomeIcons.user,
            ),
            const SizedBox(height: AppSpacing.space3),

            AppInputField(
              label: 'Manager Phone',
              placeholder: 'Enter contact number',
              controller: managerPhoneController,
              prefixIcon: FontAwesomeIcons.phone,
            ),
            const SizedBox(height: AppSpacing.space6),

            // Section 3: Amenities
            const Text(
              'Amenities',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Wrap(
                spacing: AppSpacing.space2,
                runSpacing: AppSpacing.space2,
                children: amenityOptions.map((amenity) {
                  final isSelected = selectedAmenities.contains(amenity);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedAmenities.remove(amenity);
                        } else {
                          selectedAmenities.add(amenity);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space3,
                        vertical: AppSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.green : AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(
                          color: isSelected ? AppColors.green : AppColors.gray200,
                        ),
                      ),
                      child: Text(
                        amenity,
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppColors.white : AppColors.navy,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Section 4: Capacity
            const Text(
              'Total Capacity',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Beds Available',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalCapacity beds',
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_lg,
                          fontWeight: FontWeight.w700,
                          color: AppColors.green,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          if (totalCapacity > 0) totalCapacity--;
                        }),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.gray100,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: const Center(
                            child: Icon(FontAwesomeIcons.minus,
                                size: 16, color: AppColors.navy),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space3),
                      GestureDetector(
                        onTap: () => setState(() => totalCapacity++),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: const Center(
                            child: Icon(FontAwesomeIcons.plus,
                                size: 16, color: AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.infoMain),
              ),
              child: Row(
                children: [
                  const Icon(FontAwesomeIcons.circleInfo,
                      color: AppColors.infoMain, size: 18),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Changes Summary',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            fontWeight: FontWeight.w600,
                            color: AppColors.infoMain,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${selectedAmenities.length} amenities • $totalCapacity beds',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.infoMain,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space8),

            // Action Buttons
            AppButton(
              text: 'Save Changes',
              onPressed: saveChanges,
              icon: FontAwesomeIcons.check,
            ),
            const SizedBox(height: AppSpacing.space3),
            AppButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
              variant: 'outline',
              icon: FontAwesomeIcons.xmark,
            ),
            const SizedBox(height: AppSpacing.space8),
          ],
        ),
      ),
    );
  }
}
