import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/complete_models.dart';
import '../widgets/app_button.dart';
import '../widgets/empty_state.dart';
import '../utils/toast_helper.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  // Search filters
  final searchController = TextEditingController();
  String selectedCity = 'All';
  RangeValues priceRange = const RangeValues(10000, 50000);
  double minRating = 0;
  List<String> selectedAmenities = [];
  String selectedRoomType = 'All';
  int minCapacity = 1;
  String sortBy = 'rating'; // rating, price, newest

  late List<HostelData> searchResults;
  bool showFilters = false;
  bool hasSearched = false;

  final List<String> cities = [
    'All',
    'G-11, Islamabad',
    'F-10, Islamabad',
    'Gulberg, Lahore',
    'DHA, Lahore',
    'Karachi',
    'Peshawar',
  ];

  final List<String> amenityOptions = [
    'UPS',
    'Wi-Fi',
    'Mess',
    'Laundry',
    'Security',
    'Garden',
    'AC',
    'Hot Water',
    'Study Area',
    'Common Room',
  ];

  final List<String> roomTypes = ['All', '1-Seater', '2-Seater', '3-Seater'];

  @override
  void initState() {
    super.initState();
    searchResults = [];
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void performSearch() {
    setState(() {
      hasSearched = true;
      searchResults = CompleteDummyData.hostels.where((hostel) {
        // Search query filter
        if (searchController.text.isNotEmpty &&
            !hostel.name.toLowerCase().contains(searchController.text.toLowerCase()) &&
            !hostel.address.toLowerCase().contains(searchController.text.toLowerCase())) {
          return false;
        }

        // City filter
        if (selectedCity != 'All' && hostel.city != selectedCity) {
          return false;
        }

        // Price filter
        bool priceMatch = hostel.rooms.any((room) =>
            room.pricePerBed >= priceRange.start && room.pricePerBed <= priceRange.end);
        if (!priceMatch) return false;

        // Rating filter
        if (hostel.overallRating < minRating) return false;

        // Amenities filter
        if (selectedAmenities.isNotEmpty) {
          bool hasAllAmenities = selectedAmenities
              .every((amenity) => hostel.amenities.contains(amenity));
          if (!hasAllAmenities) return false;
        }

        // Room type filter
        if (selectedRoomType != 'All') {
          bool hasRoomType = hostel.rooms.any((room) => room.type == selectedRoomType);
          if (!hasRoomType) return false;
        }

        // Capacity filter
        if (hostel.rooms.isEmpty || hostel.rooms.every((room) => room.availableBeds < minCapacity)) {
          return false;
        }

        return true;
      }).toList();

      // Apply sorting
      switch (sortBy) {
        case 'rating':
          searchResults.sort((a, b) => b.overallRating.compareTo(a.overallRating));
          break;
        case 'price':
          searchResults.sort(
            (a, b) => a.minPricePerBed.compareTo(b.minPricePerBed),
          );
          break;
        case 'newest':
        default:
          searchResults.sort((a, b) => b.registeredDate.compareTo(a.registeredDate));
      }
    });

    ToastHelper.showSuccess(context, message: 'Found ${searchResults.length} hostels');
  }

  void resetFilters() {
    setState(() {
      searchController.clear();
      selectedCity = 'All';
      priceRange = const RangeValues(10000, 50000);
      minRating = 0;
      selectedAmenities.clear();
      selectedRoomType = 'All';
      minCapacity = 1;
      sortBy = 'rating';
      hasSearched = false;
      searchResults.clear();
    });
    ToastHelper.showInfo(context, message: 'Filters reset');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Advanced Search'),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(FontAwesomeIcons.chevronLeft, color: AppColors.navy),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space4),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by name or location...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(AppSpacing.space3),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: AppSpacing.space3),
                      child: Icon(FontAwesomeIcons.magnifyingGlass,
                          color: AppColors.gray500, size: 18),
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () => setState(() => searchController.clear()),
                            child: const Padding(
                              padding: EdgeInsets.only(right: AppSpacing.space3),
                              child: Icon(FontAwesomeIcons.xmark,
                                  color: AppColors.gray500, size: 16),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),

            // Filter Toggle & Sort
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showFilters = !showFilters),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.space3,
                          vertical: AppSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: showFilters ? AppColors.greenBg : AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: showFilters ? AppColors.green : AppColors.gray200,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.sliders,
                              size: 16,
                              color: showFilters ? AppColors.green : AppColors.gray500,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              showFilters ? 'Hide Filters' : 'Show Filters',
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_sm,
                                fontWeight: FontWeight.w600,
                                color: showFilters ? AppColors.green : AppColors.gray500,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space3),
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
                        DropdownMenuItem(
                          value: 'newest',
                          child: Row(
                            children: const [
                              Icon(FontAwesomeIcons.clock, size: 14),
                              SizedBox(width: 6),
                              Text('Newest'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => sortBy = value);
                          if (hasSearched) performSearch();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            if (showFilters) ...[
              const SizedBox(height: AppSpacing.space4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // City Filter
                    const Text(
                      'City',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: DropdownButton<String>(
                        value: selectedCity,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: cities
                            .map((city) => DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedCity = value ?? 'All');
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Price Range
                    const Text(
                      'Price Range (₨)',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      '₨${priceRange.start.toInt()} - ₨${priceRange.end.toInt()}',
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    RangeSlider(
                      values: priceRange,
                      min: 5000,
                      max: 100000,
                      divisions: 19,
                      activeColor: AppColors.green,
                      inactiveColor: AppColors.gray200,
                      onChanged: (RangeValues values) {
                        setState(() => priceRange = values);
                      },
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Rating Filter
                    const Text(
                      'Minimum Rating',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () => setState(() => minRating = (index + 1).toDouble()),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                index < minRating
                                    ? FontAwesomeIcons.solidStar
                                    : FontAwesomeIcons.star,
                                size: 24,
                                color: index < minRating ? AppColors.green : AppColors.gray300,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(width: 12),
                        Text(
                          '${minRating.toInt()}+',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Room Type Filter
                    const Text(
                      'Room Type',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Wrap(
                      spacing: 8,
                      children: roomTypes.map((type) {
                        final isSelected = selectedRoomType == type;
                        return GestureDetector(
                          onTap: () => setState(() => selectedRoomType = type),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.green : AppColors.white,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                              border: Border.all(
                                color: isSelected ? AppColors.green : AppColors.gray200,
                              ),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_sm,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? AppColors.white : AppColors.navy,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Amenities Filter
                    const Text(
                      'Amenities',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.space3),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: amenityOptions.map((amenity) {
                          final isSelected = selectedAmenities.contains(amenity);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedAmenities.remove(amenity);
                                } else {
                                  selectedAmenities.add(amenity);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.green : AppColors.gray100,
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: Text(
                                amenity,
                                style: TextStyle(
                                  fontSize: AppTypography.fontSize_xs,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? AppColors.white : AppColors.navy,
                                  fontFamily: AppTypography.fontFamily,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Minimum Capacity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Minimum Capacity',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_base,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() {
                                if (minCapacity > 1) minCapacity--;
                              }),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.gray100,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: const Center(
                                  child: Icon(FontAwesomeIcons.minus,
                                      size: 14, color: AppColors.navy),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.space2),
                            Container(
                              width: 50,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(color: AppColors.gray200),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: Center(
                                child: Text(
                                  '$minCapacity',
                                  style: const TextStyle(
                                    fontSize: AppTypography.fontSize_base,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.space2),
                            GestureDetector(
                              onTap: () => setState(() => minCapacity++),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: const Center(
                                  child: Icon(FontAwesomeIcons.plus,
                                      size: 14, color: AppColors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space6),

                    // Search & Reset Buttons
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Search',
                            onPressed: performSearch,
                            icon: FontAwesomeIcons.magnifyingGlass,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.space3),
                        Expanded(
                          child: AppButton(
                            text: 'Reset',
                            onPressed: resetFilters,
                            variant: 'outline',
                            icon: FontAwesomeIcons.rotateLeft,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.space4),
              const Divider(height: 1, color: AppColors.gray100),
            ],

            // Search Results
            if (!hasSearched)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.space6),
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.info),
                  ),
                  child: Row(
                    children: [
                      const Icon(FontAwesomeIcons.circleInfo,
                          color: AppColors.info, size: 20),
                      const SizedBox(width: AppSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Configure your search',
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_sm,
                                fontWeight: FontWeight.w600,
                                color: AppColors.info,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Use filters above or search by name to find hostels',
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_xs,
                                color: AppColors.info,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (searchResults.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: EmptyState(
                  icon: FontAwesomeIcons.magnifyingGlass,
                  title: 'No Hostels Found',
                  description:
                      'Try adjusting your filters or search criteria to find what you\'re looking for',
                  buttonText: 'Reset Filters',
                  onButtonTap: resetFilters,
                  iconColor: AppColors.green,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Results (${searchResults.length})',
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_lg,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final hostel = searchResults[index];
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
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.greenBg,
                                          borderRadius:
                                              BorderRadius.circular(AppRadius.md),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            FontAwesomeIcons.building,
                                            size: 24,
                                            color: AppColors.green,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.space3),
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
                                                  size: 11,
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
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.space2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ...List.generate(5, (i) {
                                            return Icon(
                                              i < hostel.overallRating
                                                  ? FontAwesomeIcons.solidStar
                                                  : FontAwesomeIcons.star,
                                              size: 12,
                                              color: AppColors.green,
                                            );
                                          }),
                                          const SizedBox(width: 4),
                                          Text(
                                            hostel.overallRating
                                                .toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize:
                                                  AppTypography.fontSize_xs,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.green,
                                              fontFamily:
                                                  AppTypography.fontFamily,
                                            ),
                                          ),
                                        ],
                                      ),
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
            const SizedBox(height: AppSpacing.space8),
          ],
        ),
      ),
    );
  }
}
