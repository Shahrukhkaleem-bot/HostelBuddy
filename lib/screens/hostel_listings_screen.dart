import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/complete_models.dart';
import '../widgets/empty_state.dart';

class HostelListingsScreen extends StatefulWidget {
  const HostelListingsScreen({Key? key}) : super(key: key);

  @override
  State<HostelListingsScreen> createState() => _HostelListingsScreenState();
}

class _HostelListingsScreenState extends State<HostelListingsScreen> {
  late List<HostelData> filteredHostels;
  String searchQuery = '';
  String selectedCity = 'All';
  int minPrice = 10000;
  int maxPrice = 50000;
  double minRating = 0;
  bool showFilters = false;
  List<String> selectedAmenities = [];

  final List<String> cities = [
    'All',
    'G-11, Islamabad',
    'F-10, Islamabad',
    'Gulberg, Lahore',
  ];

  final List<String> amenityOptions = [
    'UPS',
    'Wi-Fi',
    'Mess',
    'Laundry',
    'Security',
    'Garden'
  ];

  @override
  void initState() {
    super.initState();
    filteredHostels = CompleteDummyData.hostels;
  }

  void _applyFilters() {
    setState(() {
      filteredHostels = CompleteDummyData.hostels.where((hostel) {
        // Search query filter
        if (searchQuery.isNotEmpty &&
            !hostel.name.toLowerCase().contains(searchQuery.toLowerCase())) {
          return false;
        }

        // City filter
        if (selectedCity != 'All' && hostel.city != selectedCity) {
          return false;
        }

        // Price filter
        bool priceMatch = hostel.rooms.any((room) =>
            room.pricePerBed >= minPrice && room.pricePerBed <= maxPrice);
        if (!priceMatch) return false;

        // Rating filter
        if (hostel.overallRating < minRating) return false;

        // Amenities filter
        if (selectedAmenities.isNotEmpty) {
          bool hasAllAmenities = selectedAmenities
              .every((amenity) => hostel.amenities.contains(amenity));
          if (!hasAllAmenities) return false;
        }

        return true;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      searchQuery = '';
      selectedCity = 'All';
      minPrice = 10000;
      maxPrice = 50000;
      minRating = 0;
      selectedAmenities = [];
      filteredHostels = CompleteDummyData.hostels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.space5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.green,
                    AppColors.green.withValues(alpha: 0.85),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find Your Hostel',
                    style: TextStyle(
                      fontSize: AppTypography.fontSize_2xl,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: AppColors.gray500,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.space3),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              searchQuery = value;
                              _applyFilters();
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search hostels...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: AppSpacing.space3,
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

            // Filter & Sort Bar
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => showFilters = !showFilters);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.space3,
                          vertical: AppSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: showFilters ? AppColors.green : AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(
                            color: showFilters
                                ? AppColors.green
                                : AppColors.gray200,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.sliders,
                              size: 16,
                              color: showFilters
                                  ? AppColors.white
                                  : AppColors.navy,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filters',
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_sm,
                                fontWeight: FontWeight.w600,
                                color: showFilters
                                    ? AppColors.white
                                    : AppColors.navy,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space3),
                  if (selectedCity != 'All' ||
                      minPrice != 10000 ||
                      maxPrice != 50000 ||
                      minRating != 0 ||
                      selectedAmenities.isNotEmpty)
                    GestureDetector(
                      onTap: _resetFilters,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.space3,
                          vertical: AppSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              FontAwesomeIcons.xmark,
                              size: 14,
                              color: AppColors.gray700,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_xs,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray700,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Filters Panel
            if (showFilters)
              Container(
                padding: const EdgeInsets.all(AppSpacing.space4),
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.gray100),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // City Filter
                      const Text(
                        'City',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: cities
                              .map((city) => Padding(
                                    padding: const EdgeInsets.only(
                                      right: AppSpacing.space2,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(
                                            () => selectedCity = city);
                                        _applyFilters();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: selectedCity == city
                                              ? AppColors.green
                                              : AppColors.gray100,
                                          borderRadius:
                                              BorderRadius.circular(
                                            AppRadius.full,
                                          ),
                                        ),
                                        child: Text(
                                          city,
                                          style: TextStyle(
                                            fontSize:
                                                AppTypography.fontSize_xs,
                                            fontWeight: FontWeight.w600,
                                            color: selectedCity == city
                                                ? AppColors.white
                                                : AppColors.navy,
                                            fontFamily: AppTypography
                                                .fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space4),

                      // Price Range Filter
                      const Text(
                        'Price Range (PKR)',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Min: ${minPrice.toString()}',
                                  style: const TextStyle(
                                    fontSize: AppTypography.fontSize_xs,
                                    color: AppColors.gray500,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                                Slider(
                                  value: minPrice.toDouble(),
                                  min: 5000,
                                  max: 40000,
                                  onChanged: (value) {
                                    setState(
                                        () => minPrice = value.toInt());
                                    _applyFilters();
                                  },
                                  activeColor: AppColors.green,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Max: ${maxPrice.toString()}',
                                  style: const TextStyle(
                                    fontSize: AppTypography.fontSize_xs,
                                    color: AppColors.gray500,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                                Slider(
                                  value: maxPrice.toDouble(),
                                  min: 10000,
                                  max: 50000,
                                  onChanged: (value) {
                                    setState(
                                        () => maxPrice = value.toInt());
                                    _applyFilters();
                                  },
                                  activeColor: AppColors.green,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.space4),

                      // Rating Filter
                      const Text(
                        'Minimum Rating',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      Row(
                        children: List.generate(5, (index) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() =>
                                    minRating = (index + 1).toDouble());
                                _applyFilters();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: minRating >= (index + 1)
                                      ? AppColors.green
                                      : AppColors.gray100,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                  border: Border.all(
                                    color: minRating >= (index + 1)
                                        ? AppColors.green
                                        : AppColors.gray200,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}⭐',
                                    style: TextStyle(
                                      fontSize: AppTypography.fontSize_xs,
                                      fontWeight: FontWeight.w600,
                                      color: minRating >= (index + 1)
                                          ? AppColors.white
                                          : AppColors.navy,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: AppSpacing.space4),

                      // Amenities Filter
                      const Text(
                        'Amenities',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: amenityOptions
                            .map((amenity) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedAmenities
                                          .contains(amenity)) {
                                        selectedAmenities.remove(amenity);
                                      } else {
                                        selectedAmenities.add(amenity);
                                      }
                                    });
                                    _applyFilters();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedAmenities
                                              .contains(amenity)
                                          ? AppColors.green
                                          : AppColors.gray100,
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.full),
                                    ),
                                    child: Text(
                                      amenity,
                                      style: TextStyle(
                                        fontSize:
                                            AppTypography.fontSize_xs,
                                        fontWeight: FontWeight.w600,
                                        color: selectedAmenities
                                                .contains(amenity)
                                            ? AppColors.white
                                            : AppColors.navy,
                                        fontFamily: AppTypography.fontFamily,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.space2),

            // Hostels List
            Expanded(
              child: filteredHostels.isEmpty
                  ? EmptyState(
                      icon: FontAwesomeIcons.building,
                      title: 'No Hostels Found',
                      description:
                          'Try adjusting your filters to see more options.',
                      buttonText: 'Reset Filters',
                      onButtonTap: _resetFilters,
                      iconColor: AppColors.green,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space4,
                        vertical: AppSpacing.space3,
                      ),
                      itemCount: filteredHostels.length,
                      itemBuilder: (context, index) {
                        final hostel = filteredHostels[index];
                        return _buildHostelCard(hostel);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHostelCard(HostelData hostel) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/hostel-details',
        arguments: hostel,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.space4),
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
            // Image
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.lg),
                  topRight: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Center(
                child: Text(
                  hostel.imageUrl,
                  style: const TextStyle(fontSize: 60),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hostel.name,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_base,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.star,
                              size: 12,
                              color: AppColors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${hostel.overallRating}',
                              style: const TextStyle(
                                fontSize: AppTypography.fontSize_sm,
                                fontWeight: FontWeight.w600,
                                color: AppColors.green,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.mapPin,
                        size: 14,
                        color: AppColors.gray500,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        hostel.city,
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          color: AppColors.gray500,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  // Amenities
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: hostel.amenities.take(3).map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          amenity,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray700,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  // Price & Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From PKR ${hostel.rooms.first.pricePerBed}',
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_sm,
                              fontWeight: FontWeight.w700,
                              color: AppColors.green,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                          Text(
                            'per bed/month',
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_xs,
                              color: AppColors.gray500,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${hostel.totalReviews} reviews',
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
          ],
        ),
      ),
    );
  }
}
