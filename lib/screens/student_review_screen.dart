import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/complete_models.dart';
import '../widgets/app_button.dart';
import '../utils/toast_helper.dart';

class StudentReviewScreen extends StatefulWidget {
  final HostelData hostel;

  const StudentReviewScreen({Key? key, required this.hostel}) : super(key: key);

  @override
  State<StudentReviewScreen> createState() => _StudentReviewScreenState();
}

class _StudentReviewScreenState extends State<StudentReviewScreen> {
  // Set once the success pop is scheduled, so repeat taps can't pop twice.
  bool _isSubmitting = false;
  double cleanlinessRating = 0;
  double staffRating = 0;
  double valueRating = 0;
  double locationRating = 0;
  double amenitiesRating = 0;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void submitReview() {
    if (_isSubmitting) return;
    if (cleanlinessRating == 0 ||
        staffRating == 0 ||
        valueRating == 0 ||
        locationRating == 0 ||
        amenitiesRating == 0) {
      ToastHelper.showError(context, message: 'Please rate all categories');
      return;
    }

    if (titleController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please add a review title');
      return;
    }

    if (descriptionController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please add a description');
      return;
    }

    if (descriptionController.text.length < 20) {
      ToastHelper.showError(context, message: 'Description must be at least 20 characters');
      return;
    }

    ToastHelper.showSuccess(context, message: 'Review submitted successfully!');
    _isSubmitting = true;
    Future.delayed(const Duration(seconds: 2), () {
      // Skip if the user already left, or another screen is now on top.
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      Navigator.pop(context);
    });
  }

  Widget ratingCategory(String label, double rating, Function(double) onRatingChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_base,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTypography.fontFamily,
                )),
            Text('${rating.toStringAsFixed(1)}/5',
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_sm,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                  fontFamily: AppTypography.fontFamily,
                )),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => onRatingChanged((index + 1).toDouble()),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  index < rating ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                  size: 24,
                  color: index < rating ? AppColors.green : AppColors.gray300,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final overallRating = (cleanlinessRating + staffRating + valueRating + locationRating + amenitiesRating) / 5;

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Review ${widget.hostel.name}',
            style: const TextStyle(
              fontSize: AppTypography.fontSize_lg,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: AppTypography.fontFamily,
            )),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(FontAwesomeIcons.chevronLeft, color: AppColors.navy),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hostel Info Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.building, size: 40, color: AppColors.green),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.hostel.name,
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_base,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppTypography.fontFamily,
                            )),
                        Text(widget.hostel.address,
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_xs,
                              fontWeight: FontWeight.w400,
                              color: AppColors.gray500,
                              fontFamily: AppTypography.fontFamily,
                            ),
                            maxLines: 1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space5),

            // Overall Rating Display
            if (overallRating > 0)
              Center(
                child: Column(
                  children: [
                    const Text('Overall Rating',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppTypography.fontFamily,
                        )),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(overallRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_2xl,
                              fontWeight: FontWeight.w800,
                              color: AppColors.green,
                              fontFamily: AppTypography.fontFamily,
                            )),
                        const SizedBox(width: 8),
                        ...List.generate(5, (index) {
                          return Icon(
                            index < overallRating
                                ? FontAwesomeIcons.solidStar
                                : FontAwesomeIcons.star,
                            size: 20,
                            color: AppColors.green,
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space5),
                  ],
                ),
              ),

            // Rating Categories Section
            const Text('Rate Each Category',
                style: TextStyle(
                  fontSize: AppTypography.fontSize_lg,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTypography.fontFamily,
                )),
            const SizedBox(height: AppSpacing.space4),

            // Cleanliness
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ratingCategory('🏠 Cleanliness', cleanlinessRating, (rating) {
                setState(() => cleanlinessRating = rating);
              }),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Staff
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ratingCategory('👥 Staff & Management', staffRating, (rating) {
                setState(() => staffRating = rating);
              }),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Value
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ratingCategory('💰 Value for Money', valueRating, (rating) {
                setState(() => valueRating = rating);
              }),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Location
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ratingCategory('📍 Location', locationRating, (rating) {
                setState(() => locationRating = rating);
              }),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Amenities
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ratingCategory('🛏️ Amenities', amenitiesRating, (rating) {
                setState(() => amenitiesRating = rating);
              }),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Written Review Section
            const Text('Write Your Review',
                style: TextStyle(
                  fontSize: AppTypography.fontSize_lg,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTypography.fontFamily,
                )),
            const SizedBox(height: AppSpacing.space3),

            // Title Input
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray200),
              ),
              child: TextField(
                controller: titleController,
                maxLength: 50,
                decoration: InputDecoration(
                  hintText: 'e.g., Great place! Clean and helpful staff',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppSpacing.space3),
                  counterText: '${titleController.text.length}/50',
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Description Input
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray200),
              ),
              child: TextField(
                controller: descriptionController,
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Share your detailed experience... (min 20 characters)',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppSpacing.space3),
                  counterText: '${descriptionController.text.length}/500',
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Submit Button
            AppButton(
              text: 'Submit Review',
              onPressed: submitReview,
              icon: FontAwesomeIcons.check,
            ),
            const SizedBox(height: AppSpacing.space3),

            // Cancel Button
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
