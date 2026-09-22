import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/models.dart';
import '../widgets/app_button.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_input.dart';
import '../widgets/app_widgets.dart';

class SubmitBidScreen extends StatefulWidget {
  final String studentId;
  final String city;
  final int budget;

  const SubmitBidScreen({
    Key? key,
    required this.studentId,
    required this.city,
    required this.budget,
  }) : super(key: key);

  @override
  State<SubmitBidScreen> createState() => _SubmitBidScreenState();
}

class _SubmitBidScreenState extends State<SubmitBidScreen> {
  late TextEditingController offerPriceController;
  late TextEditingController messageController;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    offerPriceController = TextEditingController(text: '38000');
    messageController = TextEditingController(
      text:
          'Assalam-o-Alaikum! We have a 2-seater room available with all amenities. Near NUST and Fast. Would love to host you!',
    );
  }

  @override
  void dispose() {
    offerPriceController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _submitBid() async {
    if (offerPriceController.text.isEmpty ||
        messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() => isSubmitting = false);

      // Show success
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (_) => SuccessOverlay(
          title: 'Bid Submitted!',
          subtitle:
              'Your offer has been sent to the student. You\'ll be notified if they accept.',
          duration: const Duration(milliseconds: 2500),
          onComplete: () {
            // Navigate to leads
            Navigator.pushNamed(context, '/connected-leads');
          },
        ),
      );
    }
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
                title: 'Submit Bid',
                onBackPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student Request Summary
                    AppCard(
                      elevated: true,
                      padding: const EdgeInsets.all(AppSpacing.space4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.offWhite,
                          borderRadius:
                              BorderRadius.circular(AppRadius.md),
                        ),
                        padding:
                            const EdgeInsets.all(AppSpacing.space3),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student Request #${widget.studentId}',
                              style: const TextStyle(
                                fontSize: AppTypography.fontSize_xs,
                                color: AppColors.gray500,
                                letterSpacing: 0.5,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                            const SizedBox(
                                height: AppSpacing.space2),
                            Wrap(
                              spacing: AppSpacing.space3,
                              children: [
                                _DetailItem(
                                  icon: '📍',
                                  text: widget.city,
                                ),
                                _DetailItem(
                                  icon: '🛏️',
                                  text: '2-Seater',
                                ),
                                _DetailItem(
                                  icon: '₨',
                                  text:
                                      'Budget: ${DummyData.formatPrice(widget.budget)}',
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: AppSpacing.space2),
                            Wrap(
                              spacing: AppSpacing.space2,
                              children: [
                                _AmenityTag(icon: '⚡', text: 'UPS'),
                                _AmenityTag(icon: '📶', text: 'Wi-Fi'),
                                _AmenityTag(icon: '🍴', text: 'Mess'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Hostel Name
                    AppInputField(
                      label: 'Your Hostel',
                      placeholder: 'Hostel name',
                      prefixIcon: FontAwesomeIcons.hotel,
                      enabled: false,
                      controller: TextEditingController(
                        text:
                            'Green Valley Hostel · G-11, Islamabad',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Offer Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              FontAwesomeIcons.rupeeSign,
                              color: AppColors.navy,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Offer Price (per month)',
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_sm,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray700,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.space2),
                        TextField(
                          controller: offerPriceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_lg,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray900,
                            fontFamily: AppTypography.fontFamily,
                          ),
                          decoration: InputDecoration(
                            hintText: '38000',
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: AppSpacing.space4,
                              vertical: AppSpacing.space3,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppRadius.md),
                              borderSide: const BorderSide(
                                color: AppColors.gray100,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppRadius.md),
                              borderSide: const BorderSide(
                                color: AppColors.gray100,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppRadius.md),
                              borderSide: const BorderSide(
                                color: AppColors.navyLighter,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space2),
                        Text(
                          'Original price: PKR 42,000 · You\'re offering a discount!',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Original price: PKR 42,000 · ',
                                style: TextStyle(
                                  fontSize: AppTypography.fontSize_xs,
                                  color: AppColors.gray500,
                                  fontFamily: AppTypography.fontFamily,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'You\'re offering a discount!',
                                style: TextStyle(
                                  fontSize: AppTypography.fontSize_xs,
                                  color: AppColors.green,
                                  fontFamily: AppTypography.fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Custom Message
                    AppInputField(
                      label: 'Custom Message to Student',
                      placeholder:
                          'Write a personal note to the student...',
                      prefixIcon: FontAwesomeIcons.comment,
                      controller: messageController,
                      maxLines: 4,
                      minLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.space5),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: AppButton(
                text: 'Submit Bid',
                onPressed: _submitBid,
                isLoading: isSubmitting,
                icon: FontAwesomeIcons.paperPlane,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String icon;
  final String text;

  const _DetailItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$icon $text',
      style: const TextStyle(
        fontSize: AppTypography.fontSize_sm,
        color: AppColors.gray700,
        fontFamily: AppTypography.fontFamily,
      ),
    );
  }
}

class _AmenityTag extends StatelessWidget {
  final String icon;
  final String text;

  const _AmenityTag({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.greenBg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        '$icon $text',
        style: const TextStyle(
          fontSize: AppTypography.fontSize_xs,
          color: AppColors.greenDark,
          fontFamily: AppTypography.fontFamily,
        ),
      ),
    );
  }
}
