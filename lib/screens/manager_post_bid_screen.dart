import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';
import '../utils/toast_helper.dart';

class ManagerPostBidScreen extends StatefulWidget {
  const ManagerPostBidScreen({Key? key}) : super(key: key);

  @override
  State<ManagerPostBidScreen> createState() => _ManagerPostBidScreenState();
}

class _ManagerPostBidScreenState extends State<ManagerPostBidScreen> {
  // Set once the success pop is scheduled, so repeat taps can't pop twice.
  bool _isSubmitting = false;
  final studentNameController = TextEditingController();
  final priceController = TextEditingController();
  final roomTypeController = TextEditingController();

  // Wallet
  int managerCoins = 8000;
  static const int POST_BID_COIN_COST = 50;

  @override
  void dispose() {
    studentNameController.dispose();
    priceController.dispose();
    roomTypeController.dispose();
    super.dispose();
  }

  void submitBid() {
    if (_isSubmitting) return;
    if (studentNameController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter student name');
      return;
    }
    if (priceController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter bid price');
      return;
    }
    if (roomTypeController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter room type');
      return;
    }

    final price = int.tryParse(priceController.text) ?? 0;
    if (price < 5000) {
      ToastHelper.showError(context, message: 'Price must be at least ₨5,000');
      return;
    }

    // Check coins
    if (managerCoins < POST_BID_COIN_COST) {
      ToastHelper.showError(
        context,
        message: 'Insufficient coins! Need ${POST_BID_COIN_COST} coins to post bid.',
      );
      return;
    }

    // Deduct coins
    setState(() {
      managerCoins -= POST_BID_COIN_COST;
    });

    ToastHelper.showSuccess(
      context,
      message: '✓ Bid posted! -${POST_BID_COIN_COST} coins deducted',
    );
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
        title: const Text('Post a Bid'),
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
            // Info Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.greenBg,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.green),
              ),
              child: Row(
                children: [
                  const Icon(FontAwesomeIcons.circleInfo, color: AppColors.green),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(
                    child: Text(
                      'Submit your bid to the student. No description needed.',
                      style: const TextStyle(
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

            // Form Section
            const Text(
              'Bid Details',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            AppInputField(
              label: 'Student Name',
              placeholder: 'Enter student name',
              prefixIcon: FontAwesomeIcons.user,
              controller: studentNameController,
            ),
            const SizedBox(height: AppSpacing.space3),

            AppInputField(
              label: 'Room Type',
              placeholder: 'e.g., 2-Seater, 3-Seater',
              prefixIcon: FontAwesomeIcons.bed,
              controller: roomTypeController,
            ),
            const SizedBox(height: AppSpacing.space3),

            AppInputField(
              label: 'Bid Price (₨)',
              placeholder: 'Enter monthly price',
              prefixIcon: FontAwesomeIcons.moneyBill,
              keyboardType: TextInputType.number,
              controller: priceController,
            ),
            const SizedBox(height: AppSpacing.space8),

            // Submit Button
            AppButton(
              text: 'Submit Bid',
              onPressed: submitBid,
              icon: FontAwesomeIcons.check,
            ),
            const SizedBox(height: AppSpacing.space3),

            AppButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
              variant: 'outline',
              icon: FontAwesomeIcons.xmark,
            ),
          ],
        ),
      ),
    );
  }
}
