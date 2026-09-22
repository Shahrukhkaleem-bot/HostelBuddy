import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/complete_models.dart';
import '../widgets/app_button.dart';
import '../widgets/empty_state.dart';
import '../utils/toast_helper.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<HostelData> favorites;
  String sortBy = 'recent'; // recent, rating, price

  @override
  void initState() {
    super.initState();
    // Initialize with all hostels as favorites (for demo)
    favorites = List.from(CompleteDummyData.hostels);
  }

  void removeFavorite(int index) {
    setState(() {
      favorites.removeAt(index);
    });
    ToastHelper.showSuccess(context, message: 'Removed from favorites');
  }

  void sortFavorites(String newSort) {
    setState(() {
      sortBy = newSort;
      switch (newSort) {
        case 'rating':
          favorites.sort((a, b) => b.overallRating.compareTo(a.overallRating));
          break;
        case 'price':
          favorites.sort(
            (a, b) => a.minPricePerBed.compareTo(b.minPricePerBed),
          );
          break;
        case 'recent':
        default:
          // Restore original order without bringing back removed favorites
          final order = CompleteDummyData.hostels;
          favorites.sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));
      }
    });
    ToastHelper.showInfo(context, message: 'Sorted by $newSort');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('My Favorites'),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(FontAwesomeIcons.chevronLeft, color: AppColors.navy),
        ),
      ),
      body: favorites.isEmpty
          ? EmptyState(
              icon: FontAwesomeIcons.heart,
              title: 'No Favorites Yet',
              description: 'Save hostels to your favorites for quick access',
              buttonText: 'Browse Hostels',
              onButtonTap: () => Navigator.pushNamed(context, '/hostel-listings'),
              iconColor: AppColors.green,
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with count
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.space4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${favorites.length} Favorites',
                              style: const TextStyle(
                                fontSize: AppTypography.fontSize_lg,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your saved hostels',
                              style: const TextStyle(
                                fontSize: AppTypography.fontSize_sm,
                                color: AppColors.gray500,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ],
                        ),
                        // Sort dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.space3,
                            vertical: AppSpacing.space2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: AppColors.gray200),
                          ),
                          child: DropdownButton<String>(
                            value: sortBy,
                            underline: const SizedBox(),
                            items: [
                              DropdownMenuItem(
                                value: 'recent',
                                child: Row(
                                  children: const [
                                    Icon(FontAwesomeIcons.clock, size: 14),
                                    SizedBox(width: 6),
                                    Text('Recent'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'rating',
                                child: Row(
                                  children: const [
                                    Icon(FontAwesomeIcons.star, size: 14),
                                    SizedBox(width: 6),
                                    Text('Rating'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'price',
                                child: Row(
                                  children: const [
                                    Icon(FontAwesomeIcons.tag, size: 14),
                                    SizedBox(width: 6),
                                    Text('Price'),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) sortFavorites(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.gray100),

                  // Favorites List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.space4),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final hostel = favorites[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.space3),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.gray100),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/hostel-details',
                              arguments: hostel,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.space3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hostel Header
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Icon
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.greenBg,
                                        borderRadius:
                                            BorderRadius.circular(AppRadius.md),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.building,
                                          size: 28,
                                          color: AppColors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.space3),
                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            hostel.name,
                                            style: const TextStyle(
                                              fontSize:
                                                  AppTypography.fontSize_base,
                                              fontWeight: FontWeight.w700,
                                              fontFamily:
                                                  AppTypography.fontFamily,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(
                                                FontAwesomeIcons.mapPin,
                                                size: 12,
                                                color: AppColors.gray500,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  hostel.city,
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppTypography.fontSize_xs,
                                                    color: AppColors.gray500,
                                                    fontFamily:
                                                        AppTypography.fontFamily,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Remove Button
                                    GestureDetector(
                                      onTap: () => removeFavorite(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              AppRadius.full),
                                        ),
                                        child: const Icon(
                                          FontAwesomeIcons.xmark,
                                          size: 14,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.space3),

                                // Rating & Price Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Rating
                                    Row(
                                      children: [
                                        ...List.generate(5, (i) {
                                          return Icon(
                                            i < hostel.overallRating
                                                ? FontAwesomeIcons.solidStar
                                                : FontAwesomeIcons.star,
                                            size: 14,
                                            color: AppColors.green,
                                          );
                                        }),
                                        const SizedBox(width: 6),
                                        Text(
                                          hostel.overallRating
                                              .toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize:
                                                AppTypography.fontSize_sm,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.green,
                                            fontFamily:
                                                AppTypography.fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Price
                                    if (hostel.rooms.isNotEmpty)
                                      Text(
                                        '₨${hostel.rooms.first.pricePerBed}/month',
                                        style: const TextStyle(
                                          fontSize:
                                              AppTypography.fontSize_sm,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.navy,
                                          fontFamily:
                                              AppTypography.fontFamily,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.space3),

                                // Amenities
                                Wrap(
                                  spacing: 6,
                                  children: hostel.amenities
                                      .take(3)
                                      .map((amenity) => Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.greenBg,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppRadius.sm),
                                            ),
                                            child: Text(
                                              amenity,
                                              style: const TextStyle(
                                                fontSize:
                                                    AppTypography.fontSize_xs,
                                                color: AppColors.green,
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    AppTypography.fontFamily,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: AppSpacing.space3),

                                // Action Buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        text: 'View Details',
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/hostel-details',
                                            arguments: hostel,
                                          );
                                        },
                                        variant: 'outline-green',
                                        icon: FontAwesomeIcons.eye,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.space2),
                                    Expanded(
                                      child: AppButton(
                                        text: 'Book Now',
                                        onPressed: () {
                                          ToastHelper.showSuccess(
                                            context,
                                            message:
                                                'Booking feature coming soon!',
                                          );
                                        },
                                        icon: FontAwesomeIcons.check,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
