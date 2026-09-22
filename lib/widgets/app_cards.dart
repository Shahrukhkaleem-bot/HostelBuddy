import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import 'app_button.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool elevated;
  final VoidCallback? onTap;

  const AppCard({
    Key? key,
    required this.child,
    this.padding,
    this.elevated = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            if (elevated) AppShadows.md else AppShadows.sm,
          ],
          border: elevated ? null : Border.all(color: AppColors.gray100),
        ),
        padding: padding ?? const EdgeInsets.all(AppSpacing.space4),
        child: child,
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String label;
  final String subLabel;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const RoleCard({
    Key? key,
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space3,
          vertical: AppSpacing.space5,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.offWhite : AppColors.white,
          border: Border.all(
            color: selected ? AppColors.navy : AppColors.gray100,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: selected ? [AppShadows.sm] : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: selected ? AppColors.navy : AppColors.navyLighter,
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.fontSize_sm,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.navy : AppColors.gray700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: const TextStyle(
                fontSize: AppTypography.fontSize_xs,
                color: AppColors.gray500,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            if (selected) ...[
              const SizedBox(height: AppSpacing.space2),
              const Icon(
                FontAwesomeIcons.circleCheck,
                color: AppColors.green,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BidCard extends StatelessWidget {
  final String hostelName;
  final double rating;
  final int price;
  final String roomType;
  final List<String> amenities;
  final String thumbnail;
  final String statusDot; // 'new' or 'pending'
  final VoidCallback onTap;

  const BidCard({
    Key? key,
    required this.hostelName,
    required this.rating,
    required this.price,
    required this.roomType,
    required this.amenities,
    required this.thumbnail,
    required this.statusDot,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.space3),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.gray100),
          boxShadow: [AppShadows.sm],
        ),
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Text(
                  thumbnail,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusDot == 'new'
                              ? AppColors.green
                              : AppColors.warning,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hostelName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_base,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray900,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.bed, size: 12, color: AppColors.gray500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          roomType,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.circleCheck, size: 12, color: AppColors.green),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          amenities.join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'PKR ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_lg,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
                Text(
                  '⭐ $rating',
                  style: const TextStyle(
                    fontSize: AppTypography.fontSize_sm,
                    color: AppColors.warning,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final String studentId;
  final String gender;
  final String city;
  final int budget;
  final String roomType;
  final List<String> amenities;
  final int matchScore;
  final VoidCallback onBidNow;

  const MatchCard({
    Key? key,
    required this.studentId,
    required this.gender,
    required this.city,
    required this.budget,
    required this.roomType,
    required this.amenities,
    required this.matchScore,
    required this.onBidNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gray100),
      ),
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.user, size: 10, color: AppColors.gray500),
                    const SizedBox(width: 4),
                    Text(
                      '$studentId · $gender',
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_xs,
                        color: AppColors.gray500,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greenBg,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.percent, size: 10, color: AppColors.greenDark),
                    const SizedBox(width: 4),
                    Text(
                      '$matchScore% match',
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_xs,
                        fontWeight: FontWeight.w600,
                        color: AppColors.greenDark,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              _DetailItem(icon: FontAwesomeIcons.mapPin, text: city),
              const SizedBox(width: AppSpacing.space3),
              _DetailItem(icon: FontAwesomeIcons.bed, text: roomType),
              const SizedBox(width: AppSpacing.space3),
              _DetailItem(
                icon: FontAwesomeIcons.indianRupeeSign,
                text: 'PKR ${budget.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          Wrap(
            spacing: AppSpacing.space2,
            runSpacing: AppSpacing.space2,
            children: amenities
                .map((a) => _AmenityTag(amenity: a))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.space3),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Bid Now',
              onPressed: onBidNow,
              icon: FontAwesomeIcons.gavel,
              height: 44,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.gray700),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: AppTypography.fontSize_sm,
            color: AppColors.gray700,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
      ],
    );
  }
}

class _AmenityTag extends StatelessWidget {
  final String amenity;

  const _AmenityTag({required this.amenity});

  @override
  Widget build(BuildContext context) {
    final iconMap = {
      'ups': FontAwesomeIcons.bolt,
      'wifi': FontAwesomeIcons.wifi,
      'mess': FontAwesomeIcons.utensils,
      'laundry': FontAwesomeIcons.shirt,
    };
    final icon = iconMap[amenity] ?? FontAwesomeIcons.check;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.gray700),
          const SizedBox(width: 4),
          Text(
            amenity,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_xs,
              color: AppColors.gray700,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

class LeadItem extends StatelessWidget {
  final String name;
  final String phone;
  final String avatar;
  final VoidCallback onWhatsAppTap;
  final VoidCallback? onTap;

  const LeadItem({
    Key? key,
    required this.name,
    required this.phone,
    required this.avatar,
    required this.onWhatsAppTap,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gray100),
      ),
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Center(
              child: Text(
                avatar,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: AppTypography.fontSize_lg,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: AppTypography.fontSize_base,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(FontAwesomeIcons.phone, size: 12, color: AppColors.green),
                    const SizedBox(width: 4),
                    Text(
                      phone,
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        color: AppColors.gray500,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space4),
          GestureDetector(
            onTap: onWhatsAppTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.whatsapp,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Center(
                child: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: AppColors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
