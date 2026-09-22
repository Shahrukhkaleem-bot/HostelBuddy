import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/complete_models.dart';
import '../widgets/app_button.dart';
import '../utils/toast_helper.dart';

class HostelDetailsScreen extends StatefulWidget {
  final HostelData hostel;

  const HostelDetailsScreen({Key? key, required this.hostel})
      : super(key: key);

  @override
  State<HostelDetailsScreen> createState() => _HostelDetailsScreenState();
}

class _HostelDetailsScreenState extends State<HostelDetailsScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Image
            Container(
              height: 250,
              color: AppColors.green.withValues(alpha: 0.1),
              child: Stack(
                children: [
                  // Image/Placeholder
                  Center(
                    child: Text(
                      widget.hostel.imageUrl,
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                  // Back & Favorite Buttons
                  Positioned(
                    top: AppSpacing.space3,
                    left: AppSpacing.space3,
                    right: AppSpacing.space3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                FontAwesomeIcons.arrowLeft,
                                size: 18,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => isFavorite = !isFavorite);
                            ToastHelper.showSuccess(
                              context,
                              message: isFavorite
                                  ? 'Added to favorites'
                                  : 'Removed from favorites',
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                isFavorite
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                size: 18,
                                color:
                                    isFavorite ? Colors.red : AppColors.navy,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.hostel.name,
                                style: const TextStyle(
                                  fontSize: AppTypography.fontSize_2xl,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.navy,
                                  fontFamily: AppTypography.fontFamily,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.mapPin,
                                    size: 14,
                                    color: AppColors.gray500,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.hostel.address,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.star,
                                    size: 16,
                                    color: AppColors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.hostel.overallRating
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize:
                                          AppTypography.fontSize_lg,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.green,
                                      fontFamily: AppTypography.fontFamily,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${widget.hostel.totalReviews} reviews',
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
                    const SizedBox(height: AppSpacing.space5),

                    // Description
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      widget.hostel.description,
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        color: AppColors.gray700,
                        fontFamily: AppTypography.fontFamily,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space5),

                    // Rating Breakdown
                    const Text(
                      'Rating Breakdown',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    _buildRatingItem(
                      'Cleanliness',
                      widget.hostel.ratingBreakdown.cleanliness,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    _buildRatingItem(
                      'Staff',
                      widget.hostel.ratingBreakdown.staff,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    _buildRatingItem(
                      'Value',
                      widget.hostel.ratingBreakdown.value,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    _buildRatingItem(
                      'Location',
                      widget.hostel.ratingBreakdown.location,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    _buildRatingItem(
                      'Amenities',
                      widget.hostel.ratingBreakdown.amenities,
                    ),
                    const SizedBox(height: AppSpacing.space5),

                    // Amenities
                    const Text(
                      'Amenities',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.hostel.amenities
                          .map((amenity) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.green
                                      .withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.lg),
                                ),
                                child: Text(
                                  amenity,
                                  style: const TextStyle(
                                    fontSize: AppTypography.fontSize_sm,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.green,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.space5),

                    // Rooms
                    const Text(
                      'Available Rooms',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    ...widget.hostel.rooms
                        .map((room) => _buildRoomCard(room))
                        .toList(),
                    const SizedBox(height: AppSpacing.space5),

                    // Reviews
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Reviews',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_base,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => ToastHelper.showInfo(
                            context,
                            message: 'View all reviews',
                          ),
                          child: const Text(
                            'View all',
                            style: TextStyle(
                              fontSize: AppTypography.fontSize_sm,
                              fontWeight: FontWeight.w600,
                              color: AppColors.green,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    ...widget.hostel.reviews
                        .take(2)
                        .map((review) => _buildReviewCard(review))
                        .toList(),
                    const SizedBox(height: AppSpacing.space6),

                    // Contact Button
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Contact & Book',
                        onPressed: () {
                          ToastHelper.showSuccess(
                            context,
                            message: 'Booking feature coming soon',
                          );
                        },
                        icon: FontAwesomeIcons.phone,
                        height: 56,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingItem(String label, double rating) {
    int filledStars = rating.toInt();
    bool hasHalfStar = (rating % 1) > 0;

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_sm,
              color: AppColors.gray700,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              ...List.generate(5, (index) {
                if (index < filledStars) {
                  return const Icon(
                    FontAwesomeIcons.solidStar,
                    size: 14,
                    color: AppColors.green,
                  );
                } else if (index == filledStars && hasHalfStar) {
                  return const Icon(
                    FontAwesomeIcons.star,
                    size: 14,
                    color: AppColors.green,
                  );
                } else {
                  return const Icon(
                    FontAwesomeIcons.star,
                    size: 14,
                    color: AppColors.gray300,
                  );
                }
              }),
              const SizedBox(width: 8),
              Text(
                rating.toString(),
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
    );
  }

  Widget _buildRoomCard(RoomData room) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                room.type,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_base,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  'PKR ${room.pricePerBed}/month',
                  style: const TextStyle(
                    fontSize: AppTypography.fontSize_sm,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.bed,
                size: 14,
                color: AppColors.gray500,
              ),
              const SizedBox(width: 6),
              Text(
                '${room.availableBeds} available of ${room.capacity}',
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_sm,
                  color: AppColors.gray700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(HostelReviewData review) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.studentName,
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating.toInt()
                              ? FontAwesomeIcons.solidStar
                              : FontAwesomeIcons.star,
                          size: 12,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                review.rating.toString(),
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_lg,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            review.title,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_sm,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            review.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_sm,
              color: AppColors.gray700,
              fontFamily: AppTypography.fontFamily,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
