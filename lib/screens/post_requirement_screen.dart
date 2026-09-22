import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/models.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';
import '../widgets/app_selectors.dart';
import '../widgets/app_widgets.dart';
import '../utils/toast_helper.dart';

class PostRequirementScreen extends StatefulWidget {
  const PostRequirementScreen({Key? key}) : super(key: key);

  @override
  State<PostRequirementScreen> createState() => _PostRequirementScreenState();
}

class _PostRequirementScreenState extends State<PostRequirementScreen> {
  String selectedCity = 'G-11, Islamabad';
  int budget = 35000;
  int selectedSeats = 1;
  List<String> selectedAmenities = ['ups', 'wifi'];
  bool isLoading = false;

  void _broadcastRequest() async {
    // Validation
    if (selectedCity.isEmpty) {
      ToastHelper.showError(context, message: 'Please select a city');
      return;
    }
    if (budget < 5000) {
      ToastHelper.showError(context, message: 'Budget must be at least PKR 5,000');
      return;
    }
    if (selectedSeats < 1) {
      ToastHelper.showError(context, message: 'Please select a room type');
      return;
    }
    if (selectedAmenities.isEmpty) {
      ToastHelper.showWarning(
        context,
        message: 'It\'s recommended to select at least one amenity',
      );
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    // Show success toast
    ToastHelper.showSuccess(
      context,
      message: 'Requirement posted successfully!',
    );

    // Navigate after a short delay; stay in the loading state until then so
    // the button can't be tapped again.
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await Navigator.pushNamed(context, '/bids-inbox', arguments: {
      'city': selectedCity,
      'budget': budget,
      'seats': selectedSeats,
      'amenities': List<String>.from(selectedAmenities),
    });
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space5,
              ),
              child: PageHeader(
                title: 'Post Requirement',
                onBackPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // City Selection
                    AppDropdownField(
                      label: 'Study /WorkSpace Location',
                      prefixIcon: FontAwesomeIcons.locationDot,
                      items: DummyData.cities,
                      selectedItem: selectedCity,
                      onChanged: (value) =>
                          setState(() => selectedCity = value),
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Budget Slider
                    const Text(
                      'Budget per Month',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    BudgetSlider(
                      value: budget,
                      min: 5000,
                      max: 80000,
                      onChanged: (value) => setState(() => budget = value),
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Room Type Selection
                    const Text(
                      'Room Type',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Row(
                      children: [1, 2, 3, 4]
                          .map((seats) => RoomTypeButton(
                            label: '${seats}S',
                            seats: seats,
                            selected: selectedSeats == seats,
                            onTap: () =>
                                setState(() => selectedSeats = seats),
                          ))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Amenities
                    const Text(
                      'Required Amenities',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.space3,
                      crossAxisSpacing: AppSpacing.space3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        AmenityCheckbox(
                          label: 'UPS / Generator',
                          amenity: 'ups',
                          icon: '⚡',
                          selected: selectedAmenities.contains('ups'),
                          onTap: () {
                            setState(() {
                              if (selectedAmenities.contains('ups')) {
                                selectedAmenities.remove('ups');
                              } else {
                                selectedAmenities.add('ups');
                              }
                            });
                          },
                        ),
                        AmenityCheckbox(
                          label: 'Wi-Fi',
                          amenity: 'wifi',
                          icon: '📶',
                          selected: selectedAmenities.contains('wifi'),
                          onTap: () {
                            setState(() {
                              if (selectedAmenities.contains('wifi')) {
                                selectedAmenities.remove('wifi');
                              } else {
                                selectedAmenities.add('wifi');
                              }
                            });
                          },
                        ),
                        AmenityCheckbox(
                          label: '3x Mess (Halal)',
                          amenity: 'mess',
                          icon: '🍴',
                          selected: selectedAmenities.contains('mess'),
                          onTap: () {
                            setState(() {
                              if (selectedAmenities.contains('mess')) {
                                selectedAmenities.remove('mess');
                              } else {
                                selectedAmenities.add('mess');
                              }
                            });
                          },
                        ),
                        AmenityCheckbox(
                          label: 'Laundry',
                          amenity: 'laundry',
                          icon: '👕',
                          selected: selectedAmenities.contains('laundry'),
                          onTap: () {
                            setState(() {
                              if (selectedAmenities.contains('laundry')) {
                                selectedAmenities.remove('laundry');
                              } else {
                                selectedAmenities.add('laundry');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space5),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: AppButton(
                text: 'Broadcast Request',
                onPressed: _broadcastRequest,
                isLoading: isLoading,
                icon: FontAwesomeIcons.paperPlane,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
