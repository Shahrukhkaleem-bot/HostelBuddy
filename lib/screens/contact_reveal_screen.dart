import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../widgets/app_button.dart';

class ContactRevealScreen extends StatelessWidget {
  final String hostelName;
  final String studentName;
  final String hostelPhone;
  final String studentPhone;
  final String hostelManager;
  final String hostelEmail;
  final String studentEmail;
  final String roomType;
  final int price;
  final String? hostelAddress;
  final double? hostelRating;
  final List<String>? hostelAmenities;
  final String? studentGender;
  final String? studentLocation;

  const ContactRevealScreen({
    Key? key,
    required this.hostelName,
    required this.studentName,
    required this.hostelPhone,
    required this.studentPhone,
    required this.hostelManager,
    required this.hostelEmail,
    required this.studentEmail,
    required this.roomType,
    required this.price,
    this.hostelAddress,
    this.hostelRating,
    this.hostelAmenities,
    this.studentGender,
    this.studentLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Contact Information',
          style: TextStyle(
            fontSize: AppTypography.fontSize_lg,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deal Summary
            Container(
              padding: const EdgeInsets.all(AppSpacing.space4),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.green),
              ),
              child: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.circleCheck,
                    color: AppColors.green,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.space4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deal Confirmed!',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_base,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$roomType at PKR ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}/month',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            color: AppColors.greenDark,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Hostel Contact Section
            const Text(
              'Hostel Information',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            _ContactCard(
              title: hostelName,
              manager: 'Manager: $hostelManager',
              rating: hostelRating,
              address: hostelAddress,
              amenities: hostelAmenities,
              contacts: [
                {'icon': FontAwesomeIcons.phone, 'label': 'Phone', 'value': hostelPhone},
                {'icon': FontAwesomeIcons.envelope, 'label': 'Email', 'value': hostelEmail},
              ],
            ),
            const SizedBox(height: AppSpacing.space6),

            // Student Contact Section
            const Text(
              'Student Information',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            _ContactCard(
              title: studentName,
              manager: 'Student',
              gender: studentGender,
              location: studentLocation,
              contacts: [
                {'icon': FontAwesomeIcons.phone, 'label': 'Phone', 'value': studentPhone},
                {'icon': FontAwesomeIcons.envelope, 'label': 'Email', 'value': studentEmail},
              ],
            ),
            const SizedBox(height: AppSpacing.space6),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Call Hostel',
                    onPressed: () {
                      // Handle call
                    },
                    variant: 'outline',
                    icon: FontAwesomeIcons.phone,
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: AppButton(
                    text: 'Message',
                    onPressed: () {
                      // Handle message
                    },
                    icon: FontAwesomeIcons.commentDots,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space4),

            // Next Steps
            Container(
              padding: const EdgeInsets.all(AppSpacing.space4),
              decoration: BoxDecoration(
                color: AppColors.bgSubtle,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.gray100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Next Steps',
                    style: TextStyle(
                      fontSize: AppTypography.fontSize_base,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  _StepItem(
                    number: 1,
                    title: 'Contact the hostel',
                    description: 'Call or message to confirm room details',
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  _StepItem(
                    number: 2,
                    title: 'Schedule a visit',
                    description: 'Visit the hostel to finalize the booking',
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  _StepItem(
                    number: 3,
                    title: 'Complete registration',
                    description: 'Sign agreement and pay advance deposit',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final String manager;
  final List<Map<String, dynamic>> contacts;
  final double? rating;
  final String? address;
  final List<String>? amenities;
  final String? gender;
  final String? location;

  const _ContactCard({
    required this.title,
    required this.manager,
    required this.contacts,
    this.rating,
    this.address,
    this.amenities,
    this.gender,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gray100),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Icon(
                    manager.contains('Manager') ? FontAwesomeIcons.building : FontAwesomeIcons.user,
                    color: AppColors.navy,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      manager,
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        color: AppColors.gray500,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    if (rating != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.star, size: 12, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            '$rating★ Rating',
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_xs,
                              color: AppColors.warning,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space4),
          if (address != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(FontAwesomeIcons.mapPin, size: 14, color: AppColors.green),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Address',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_xs,
                          color: AppColors.gray500,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      Text(
                        address!,
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space4),
            Container(
              height: 1,
              color: AppColors.gray100,
            ),
            const SizedBox(height: AppSpacing.space4),
          ],
          if (amenities != null && amenities!.isNotEmpty) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Amenities',
                  style: TextStyle(
                    fontSize: AppTypography.fontSize_xs,
                    color: AppColors.gray500,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: amenities!
                      .map((amenity) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gray50,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              amenity,
                              style: const TextStyle(
                                fontSize: AppTypography.fontSize_xs,
                                color: AppColors.gray700,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space4),
            Container(
              height: 1,
              color: AppColors.gray100,
            ),
            const SizedBox(height: AppSpacing.space4),
          ],
          if (gender != null || location != null) ...[
            Row(
              children: [
                if (gender != null) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        Text(
                          gender!,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (location != null) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Looking for',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        Text(
                          location!,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.space4),
            Container(
              height: 1,
              color: AppColors.gray100,
            ),
            const SizedBox(height: AppSpacing.space4),
          ],
          ...contacts.asMap().entries.map((entry) {
            bool isLast = entry.key == contacts.length - 1;
            var contact = entry.value;
            return Column(
              children: [
                Row(
                  children: [
                    Icon(
                      contact['icon'],
                      size: 16,
                      color: AppColors.green,
                    ),
                    const SizedBox(width: AppSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact['label'],
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_xs,
                              color: AppColors.gray500,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                          Text(
                            contact['value'],
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_base,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      FontAwesomeIcons.copy,
                      size: 14,
                      color: AppColors.gray300,
                    ),
                  ],
                ),
                if (!isLast) ...[
                  const SizedBox(height: AppSpacing.space4),
                  Container(
                    height: 1,
                    color: AppColors.gray100,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                ],
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String title;
  final String description;

  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: AppTypography.fontSize_base,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_sm,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
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
    );
  }
}
