import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../widgets/app_button.dart';
import '../utils/toast_helper.dart';

class HostelReviewScreen extends StatefulWidget {
  final String studentName;
  final String hostelName;

  const HostelReviewScreen({
    Key? key,
    required this.studentName,
    required this.hostelName,
  }) : super(key: key);

  @override
  State<HostelReviewScreen> createState() => _HostelReviewScreenState();
}

class _HostelReviewScreenState extends State<HostelReviewScreen> {
  // Set once the success pop is scheduled, so repeat taps can't pop twice.
  bool _isSubmitting = false;
  double behaviorRating = 0;
  double paymentRating = 0;
  double propertyRating = 0;
  double communicationRating = 0;
  double relationsRating = 0;

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
    if (behaviorRating == 0 ||
        paymentRating == 0 ||
        propertyRating == 0 ||
        communicationRating == 0 ||
        relationsRating == 0) {
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

    ToastHelper.showSuccess(context, message: 'Student review submitted successfully!');
    _isSubmitting = true;
    Future.delayed(const Duration(seconds: 2), () {
      // Skip if the user already left, or another screen is now on top.
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      Navigator.pop(context);
    });
  }

  Widget ratingCategory(String label, String description, double rating, Function(double) onRatingChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTypography.fontFamily,
                      )),
                  Text(description,
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
    final overallRating =
        (behaviorRating + paymentRating + propertyRating + communicationRating + relationsRating) / 5;

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Rate Student',
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
            // Student Info Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.user, size: 40, color: AppColors.green),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.studentName,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_base,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        Text(
                          'Stay at ${widget.hostelName}',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
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
            const Text('Rate Student',
                style: TextStyle(
                  fontSize: AppTypography.fontSize_lg,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTypography.fontFamily,
                )),
            const SizedBox(height: AppSpacing.space4),

            // Behavior
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ratingCategory(
                '🏠 Behavior & Conduct',
                'Follows rules, respectful, no disturbances',
                behaviorRating,
                (rating) => setState(() => behaviorRating = rating),
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Payment Reliability
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ratingCategory(
                '💰 Payment Reliability',
                'Pays on time, no disputes (MOST IMPORTANT)',
                paymentRating,
                (rating) => setState(() => paymentRating = rating),
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Property Care
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ratingCategory(
                '🛡️ Property Care',
                'Maintains room, reports damages',
                propertyRating,
                (rating) => setState(() => propertyRating = rating),
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Communication
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ratingCategory(
                '📞 Communication',
                'Responsive to messages, cooperative',
                communicationRating,
                (rating) => setState(() => communicationRating = rating),
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Relations
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ratingCategory(
                '🤝 Tenant Relations',
                'Gets along with others, community fit',
                relationsRating,
                (rating) => setState(() => relationsRating = rating),
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Written Review Section
            const Text('Write Your Feedback',
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
                  hintText: 'e.g., Excellent tenant, always on time',
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
                  hintText: 'Share your experience with this tenant... (min 20 characters)',
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
