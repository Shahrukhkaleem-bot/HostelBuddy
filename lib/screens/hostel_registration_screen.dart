import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';
import '../utils/toast_helper.dart';

class HostelRegistrationScreen extends StatefulWidget {
  const HostelRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<HostelRegistrationScreen> createState() =>
      _HostelRegistrationScreenState();
}

class _HostelRegistrationScreenState extends State<HostelRegistrationScreen> {
  late PageController _pageController;
  int _currentStep = 0;

  // Form data
  String hostelName = '';
  String hostelPhone = '';
  String hostelAddress = '';
  String hostelDescription = '';
  String selectedCity = 'G-11, Islamabad';
  List<String> selectedAmenities = [];
  int totalRooms = 10;
  int pricePerBed = 30000;
  bool isLoading = false;

  final List<String> cities = [
    'G-11, Islamabad',
    'G-10, Islamabad',
    'F-10, Islamabad',
    'Gulberg, Lahore',
    'Johar Town, Lahore',
    'Clifton, Karachi',
    'Gulshan, Karachi',
  ];

  final List<Map<String, dynamic>> amenities = [
    {'label': 'UPS/Generator', 'value': 'ups', 'icon': FontAwesomeIcons.bolt},
    {'label': 'Wi-Fi', 'value': 'wifi', 'icon': FontAwesomeIcons.wifi},
    {'label': '3x Mess', 'value': 'mess', 'icon': FontAwesomeIcons.utensils},
    {'label': 'Laundry', 'value': 'laundry', 'icon': FontAwesomeIcons.shirt},
    {
      'label': '24/7 Security',
      'value': 'security',
      'icon': FontAwesomeIcons.shield
    },
    {'label': 'AC Rooms', 'value': 'ac', 'icon': FontAwesomeIcons.fan},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitRegistration() async {
    // Validation
    if (hostelName.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter hostel name');
      return;
    }
    if (hostelPhone.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter hostel phone number');
      return;
    }
    if (hostelPhone.length < 10) {
      ToastHelper.showError(context, message: 'Please enter a valid phone number');
      return;
    }
    if (hostelAddress.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter hostel address');
      return;
    }
    if (hostelDescription.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter hostel description');
      return;
    }
    if (selectedAmenities.isEmpty) {
      ToastHelper.showWarning(
        context,
        message: 'Please select at least one amenity',
      );
      return;
    }
    if (pricePerBed < 5000) {
      ToastHelper.showError(
        context,
        message: 'Price must be at least PKR 5,000',
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    ToastHelper.showSuccess(
      context,
      message: 'Hostel registered successfully!',
    );

    // Stay in the loading state until navigation so the button can't be
    // tapped again.
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/warden-home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Register Your Hostel',
          style: TextStyle(
            fontSize: AppTypography.fontSize_lg,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
        leading: _currentStep == 0
            ? null
            : GestureDetector(
                onTap: _previousStep,
                child: Container(
                  margin: const EdgeInsets.all(AppSpacing.space3),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.arrowLeft,
                      size: 16,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space4),
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(
                      right: index < 3 ? AppSpacing.space2 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? AppColors.green
                          : AppColors.gray200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Form Steps
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _currentStep = index);
              },
              children: [
                // Step 1: Hostel Basic Info
                _buildStep1(),
                // Step 2: Location & Description
                _buildStep2(),
                // Step 3: Amenities
                _buildStep3(),
                // Step 4: Pricing & Rooms
                _buildStep4(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hostel Information',
            style: TextStyle(
              fontSize: AppTypography.fontSize_lg,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          AppInputField(
            label: 'Hostel Name',
            placeholder: 'Enter your hostel name',
            prefixIcon: FontAwesomeIcons.building,
            onChanged: (value) => hostelName = value,
          ),
          const SizedBox(height: AppSpacing.space4),
          AppInputField(
            label: 'Hostel Phone Number',
            placeholder: '0300-1234567',
            prefixIcon: FontAwesomeIcons.phone,
            keyboardType: TextInputType.phone,
            onChanged: (value) => hostelPhone = value,
          ),
          const SizedBox(height: AppSpacing.space6),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Next',
              onPressed: _nextStep,
              icon: FontAwesomeIcons.chevronRight,
              height: 56,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location & Description',
            style: TextStyle(
              fontSize: AppTypography.fontSize_lg,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          _buildDropdown(
            label: 'City/Location',
            value: selectedCity,
            items: cities,
            onChanged: (value) => setState(() => selectedCity = value),
          ),
          const SizedBox(height: AppSpacing.space4),
          AppInputField(
            label: 'Hostel Address',
            placeholder: 'Street address, building details',
            prefixIcon: FontAwesomeIcons.mapPin,
            maxLines: 2,
            onChanged: (value) => hostelAddress = value,
          ),
          const SizedBox(height: AppSpacing.space4),
          AppInputField(
            label: 'Hostel Description',
            placeholder: 'Tell us about your hostel...',
            prefixIcon: FontAwesomeIcons.penToSquare,
            maxLines: 4,
            onChanged: (value) => hostelDescription = value,
          ),
          const SizedBox(height: AppSpacing.space6),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Back',
                  onPressed: _previousStep,
                  variant: 'outline',
                  icon: FontAwesomeIcons.chevronLeft,
                  height: 56,
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: AppButton(
                  text: 'Next',
                  onPressed: _nextStep,
                  icon: FontAwesomeIcons.chevronRight,
                  height: 56,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amenities',
            style: TextStyle(
              fontSize: AppTypography.fontSize_lg,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          const SizedBox(height: AppSpacing.space2),
          const Text(
            'Select amenities available in your hostel',
            style: TextStyle(
              fontSize: AppTypography.fontSize_sm,
              color: AppColors.gray500,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.space3,
            crossAxisSpacing: AppSpacing.space3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: amenities
                .map((amenity) => _buildAmenityCard(amenity))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.space6),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Back',
                  onPressed: _previousStep,
                  variant: 'outline',
                  icon: FontAwesomeIcons.chevronLeft,
                  height: 56,
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: AppButton(
                  text: 'Next',
                  onPressed: _nextStep,
                  icon: FontAwesomeIcons.chevronRight,
                  height: 56,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pricing & Capacity',
            style: TextStyle(
              fontSize: AppTypography.fontSize_lg,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          _buildNumberInput(
            label: 'Total Rooms',
            value: totalRooms,
            onChanged: (value) => setState(() => totalRooms = value),
          ),
          const SizedBox(height: AppSpacing.space4),
          _buildNumberInput(
            label: 'Price Per Bed (PKR)',
            value: pricePerBed,
            onChanged: (value) => setState(() => pricePerBed = value),
          ),
          const SizedBox(height: AppSpacing.space4),
          Container(
            padding: const EdgeInsets.all(AppSpacing.space4),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.circleInfo,
                  color: AppColors.green,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: Text(
                    'You can update these details anytime from your dashboard',
                    style: TextStyle(
                      fontSize: AppTypography.fontSize_sm,
                      color: AppColors.green,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space6),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Back',
                  onPressed: _previousStep,
                  variant: 'outline',
                  icon: FontAwesomeIcons.chevronLeft,
                  height: 56,
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: AppButton(
                  text: 'Complete',
                  onPressed: _submitRegistration,
                  isLoading: isLoading,
                  icon: FontAwesomeIcons.check,
                  height: 56,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTypography.fontSize_sm,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
        const SizedBox(height: AppSpacing.space2),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.gray200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (newValue) {
                if (newValue != null) onChanged(newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmenityCard(Map<String, dynamic> amenity) {
    bool isSelected = selectedAmenities.contains(amenity['value']);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedAmenities.remove(amenity['value']);
          } else {
            selectedAmenities.add(amenity['value']);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.green : AppColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              amenity['icon'],
              color: isSelected ? AppColors.white : AppColors.green,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              amenity['label'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTypography.fontSize_sm,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.navy,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTypography.fontSize_sm,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
        const SizedBox(height: AppSpacing.space2),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space3,
            vertical: AppSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.gray200),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onChanged(value > 1 ? value - 1 : value),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.minus,
                      size: 16,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: AppTypography.fontSize_lg,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onChanged(value + 1),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.plus,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
