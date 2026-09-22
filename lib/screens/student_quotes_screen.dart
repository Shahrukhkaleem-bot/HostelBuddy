import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/complete_models.dart';
import '../widgets/app_button.dart';

class StudentQuotesScreen extends StatefulWidget {
  const StudentQuotesScreen({Key? key}) : super(key: key);

  @override
  State<StudentQuotesScreen> createState() => _StudentQuotesScreenState();
}

class QuoteBid {
  final int id;
  final String hostelName;
  final String roomType;
  final int price;
  final String status; // received, pending, closed
  final DateTime date;
  final bool isAccepted;
  final String managerName;
  final String hostelPhone;
  final String hostelManager;
  final String hostelAddress;
  final String requirementTitle; // Which requirement this bid is for

  QuoteBid({
    required this.id,
    required this.hostelName,
    required this.roomType,
    required this.price,
    required this.status,
    required this.date,
    required this.isAccepted,
    required this.managerName,
    required this.hostelPhone,
    required this.hostelManager,
    required this.hostelAddress,
    required this.requirementTitle,
  });
}

class _StudentQuotesScreenState extends State<StudentQuotesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Dummy bids data
  late List<QuoteBid> allBids;

  // Wallet/Coins
  int studentCoins = 5000;
  static const int REVIEW_COIN_COST = 100;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize dummy data
    allBids = [
      // Received bids
      QuoteBid(
        id: 1,
        hostelName: 'Al-Haram Hostel',
        roomType: '2-Seater',
        price: 25000,
        status: 'received',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isAccepted: false,
        managerName: 'Hassan Khan',
        hostelPhone: '0312-3456789',
        hostelManager: 'Hassan Khan',
        hostelAddress: 'F-11, Islamabad',
        requirementTitle: 'Looking for 2-Seater in Islamabad',
      ),
      QuoteBid(
        id: 2,
        hostelName: 'Green Valley Hostel',
        roomType: '1-Seater',
        price: 20000,
        status: 'received',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isAccepted: false,
        managerName: 'Ali Ahmed',
        hostelPhone: '0321-9876543',
        hostelManager: 'Ali Ahmed',
        hostelAddress: 'G-11, Islamabad',
        requirementTitle: 'Budget Friendly 1-Seater',
      ),
      QuoteBid(
        id: 3,
        hostelName: 'City Tower Hostel',
        roomType: '3-Seater',
        price: 30000,
        status: 'received',
        date: DateTime.now(),
        isAccepted: false,
        managerName: 'Muhammad Saeed',
        hostelPhone: '0333-1234567',
        hostelManager: 'Muhammad Saeed',
        hostelAddress: 'H-8, Islamabad',
        requirementTitle: '3-Seater with WiFi & UPS',
      ),
      // Pending bids
      QuoteBid(
        id: 4,
        hostelName: 'Elite Hostel',
        roomType: '2-Seater',
        price: 28000,
        status: 'pending',
        date: DateTime.now().subtract(const Duration(days: 3)),
        isAccepted: false,
        managerName: 'Fatima Ali',
        hostelPhone: '0345-5555555',
        hostelManager: 'Fatima Ali',
        hostelAddress: 'I-9, Islamabad',
        requirementTitle: 'Premium 2-Seater with AC',
      ),
      // Closed bids (accepted)
      QuoteBid(
        id: 5,
        hostelName: 'Premium Residency',
        roomType: '1-Seater',
        price: 22000,
        status: 'closed',
        date: DateTime.now().subtract(const Duration(days: 5)),
        isAccepted: true,
        managerName: 'Usman Khan',
        hostelPhone: '0312-8888888',
        hostelManager: 'Usman Khan',
        hostelAddress: 'J-10, Islamabad',
        requirementTitle: 'Comfortable 1-Seater Room',
      ),
      // Closed bids (rejected)
      QuoteBid(
        id: 6,
        hostelName: 'Budget Inn',
        roomType: '2-Seater',
        price: 15000,
        status: 'closed',
        date: DateTime.now().subtract(const Duration(days: 4)),
        isAccepted: false,
        managerName: 'Aisha Malik',
        hostelPhone: '0322-7777777',
        hostelManager: 'Aisha Malik',
        hostelAddress: 'K-11, Islamabad',
        requirementTitle: 'Economy 2-Seater Room',
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<QuoteBid> getFilteredBids(String status) {
    return allBids.where((bid) => bid.status == status).toList();
  }

  void showContactDetails(QuoteBid bid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.gray50,
      builder: (context) => ContactDetailSheet(
        bid: bid,
        onContinue: () {
          Navigator.pop(context);
          moveToPending(bid);
        },
        studentCoins: studentCoins,
        coinCost: REVIEW_COIN_COST,
      ),
    );
  }

  void moveToPending(QuoteBid bid) {
    if (studentCoins < REVIEW_COIN_COST) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient coins')),
      );
      return;
    }

    setState(() {
      studentCoins -= REVIEW_COIN_COST;

      final index = allBids.indexWhere((b) => b.id == bid.id);
      if (index != -1) {
        allBids[index] = QuoteBid(
          id: bid.id,
          hostelName: bid.hostelName,
          roomType: bid.roomType,
          price: bid.price,
          status: 'pending',
          date: bid.date,
          isAccepted: bid.isAccepted,
          managerName: bid.managerName,
          hostelPhone: bid.hostelPhone,
          hostelManager: bid.hostelManager,
          hostelAddress: bid.hostelAddress,
          requirementTitle: bid.requirementTitle,
        );
      }
    });
  }

  void closeBid(QuoteBid bid, bool accept) {
    setState(() {
      final index = allBids.indexWhere((b) => b.id == bid.id);
      if (index != -1) {
        allBids[index] = QuoteBid(
          id: bid.id,
          hostelName: bid.hostelName,
          roomType: bid.roomType,
          price: bid.price,
          status: 'closed',
          date: bid.date,
          isAccepted: accept,
          managerName: bid.managerName,
          hostelPhone: bid.hostelPhone,
          hostelManager: bid.hostelManager,
          hostelAddress: bid.hostelAddress,
          requirementTitle: bid.requirementTitle,
        );
      }
    });

    // Show review dialog
    showReviewDialog(bid, accept);
  }

  // The review route expects a HostelData; match a known hostel by name and
  // fall back to one built from the bid so the review targets the right hostel.
  HostelData hostelForBid(QuoteBid bid) {
    for (final hostel in CompleteDummyData.hostels) {
      if (hostel.name == bid.hostelName) return hostel;
    }
    return HostelData(
      id: bid.id, name: bid.hostelName, address: bid.hostelAddress,
      city: bid.hostelAddress, latitude: 0, longitude: 0, description: '',
      managerName: bid.hostelManager, managerPhone: bid.hostelPhone,
      overallRating: 0, totalReviews: 0, amenities: const [], rooms: const [],
      totalCapacity: 0, imageUrl: '', galleryImages: const [],
      ratingBreakdown: RatingBreakdown(
        cleanliness: 0, staff: 0, value: 0, location: 0, amenities: 0),
      reviews: const [], registeredDate: bid.date,
    );
  }

  void showReviewDialog(QuoteBid bid, bool wasAccepted) {
    showDialog(
      context: context,
      builder: (dialogContext) => ReviewDecisionDialog(
        hostelName: bid.hostelName,
        wasAccepted: wasAccepted,
        onReviewNow: () {
          Navigator.pop(dialogContext);
          // Navigate to review screen
          Navigator.pushNamed(
            context,
            '/student-review',
            arguments: hostelForBid(bid),
          );
        },
        onReviewLater: () {
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('My Quotes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Coin Badge
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space3,
                  vertical: AppSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greenBg,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.green),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(FontAwesomeIcons.coins,
                        size: 16, color: AppColors.green),
                    const SizedBox(width: 8),
                    Text(
                      '$studentCoins coins',
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.space2),
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: AppColors.green,
                unselectedLabelColor: AppColors.gray500,
                indicatorColor: AppColors.green,
                tabs: const [
                  Tab(text: 'Received'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Closed'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBidsList('received'),
          _buildBidsList('pending'),
          _buildBidsList('closed'),
        ],
      ),
    );
  }

  Widget _buildBidsList(String status) {
    final bids = getFilteredBids(status);

    if (bids.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.inbox,
              size: 50,
              color: AppColors.gray300,
            ),
            const SizedBox(height: AppSpacing.space3),
            Text(
              'No ${status} bids',
              style: const TextStyle(
                fontSize: AppTypography.fontSize_base,
                color: AppColors.gray500,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.space4),
      itemCount: bids.length,
      itemBuilder: (context, index) {
        final bid = bids[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.space3),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.gray100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bid.hostelName,
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_base,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bid.managerName,
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_xs,
                              color: AppColors.gray500,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.infoLight,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Text(
                              bid.requirementTitle,
                              style: const TextStyle(
                                fontSize: AppTypography.fontSize_xs,
                                color: AppColors.info,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: status == 'closed'
                            ? (bid.isAccepted
                                ? AppColors.greenBg
                                : AppColors.error.withValues(alpha: 0.1))
                            : AppColors.infoLight,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        status == 'closed'
                            ? (bid.isAccepted ? 'Accepted' : 'Rejected')
                            : (status == 'received' ? 'New' : 'Reviewing'),
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_xs,
                          fontWeight: FontWeight.w600,
                          color: AppColors.info,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space3),

                // Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room Type',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        Text(
                          bid.roomType,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Price',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        Text(
                          '₨${bid.price}/month',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space3),

                // Actions
                if (status == 'received')
                  AppButton(
                    text: 'Review Bid',
                    onPressed: () => showContactDetails(bid),
                    icon: FontAwesomeIcons.phone,
                  )
                else if (status == 'pending')
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Accept',
                          onPressed: () => closeBid(bid, true),
                          icon: FontAwesomeIcons.check,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space2),
                      Expanded(
                        child: AppButton(
                          text: 'Reject',
                          onPressed: () => closeBid(bid, false),
                          variant: 'outline',
                          icon: FontAwesomeIcons.xmark,
                        ),
                      ),
                    ],
                  )
                else if (status == 'closed')
                  AppButton(
                    text: 'Review Hostel',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/student-review',
                        arguments: hostelForBid(bid),
                      );
                    },
                    icon: FontAwesomeIcons.star,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ContactDetailSheet extends StatelessWidget {
  final QuoteBid bid;
  final VoidCallback onContinue;
  final int studentCoins;
  final int coinCost;

  const ContactDetailSheet({
    required this.bid,
    required this.onContinue,
    required this.studentCoins,
    required this.coinCost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hostel Details',
                  style: TextStyle(
                    fontSize: AppTypography.fontSize_lg,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: const Center(
                      child: Icon(FontAwesomeIcons.xmark, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space4),

            // Hostel Info Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bid.hostelName,
                    style: const TextStyle(
                      fontSize: AppTypography.fontSize_lg,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  // Manager
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.user,
                          size: 16, color: AppColors.gray700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manager',
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_xs,
                                color: AppColors.gray500,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                            Text(
                              bid.hostelManager,
                              style: const TextStyle(
                                fontSize: AppTypography.fontSize_sm,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  // Phone
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.phone,
                          size: 16, color: AppColors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone',
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_xs,
                                color: AppColors.gray500,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                            Text(
                              bid.hostelPhone,
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
                  const SizedBox(height: AppSpacing.space3),
                  // Address
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.mapPin,
                          size: 16, color: AppColors.gray700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address',
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_xs,
                                color: AppColors.gray500,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                            Text(
                              bid.hostelAddress,
                              style: const TextStyle(
                                fontSize: AppTypography.fontSize_sm,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space4),

            // Bid Info
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.greenBg,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Room Type',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          color: AppColors.green,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      Text(
                        bid.roomType,
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w700,
                          color: AppColors.green,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          color: AppColors.green,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      Text(
                        '₨${bid.price}/month',
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w700,
                          color: AppColors.green,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space4),

            // Coin Deduction Info
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.info),
              ),
              child: Row(
                children: [
                  const Icon(FontAwesomeIcons.coins,
                      size: 20, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Review this bid',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            color: AppColors.info,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        Text(
                          '-$coinCost coins (from both parties)',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            fontWeight: FontWeight.w600,
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
            const SizedBox(height: AppSpacing.space4),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: GestureDetector(
                    onTap: onContinue,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ),
                    ),
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

class ReviewDecisionDialog extends StatelessWidget {
  final String hostelName;
  final bool wasAccepted;
  final VoidCallback onReviewNow;
  final VoidCallback onReviewLater;

  const ReviewDecisionDialog({
    required this.hostelName,
    required this.wasAccepted,
    required this.onReviewNow,
    required this.onReviewLater,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: wasAccepted
                    ? AppColors.greenBg
                    : AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  wasAccepted ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
                  size: 28,
                  color: wasAccepted ? AppColors.green : AppColors.error,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Title
            Text(
              wasAccepted ? 'Bid Accepted!' : 'Bid Rejected',
              style: const TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space2),

            // Message
            Text(
              wasAccepted
                  ? 'Would you like to review $hostelName now?'
                  : 'You rejected the bid from $hostelName',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppTypography.fontSize_sm,
                color: AppColors.gray700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space5),

            // Buttons
            GestureDetector(
              onTap: onReviewNow,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Center(
                  child: Text(
                    'Review Now',
                    style: TextStyle(
                      fontSize: AppTypography.fontSize_sm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onReviewLater,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Center(
                  child: Text(
                    'Review Later',
                    style: TextStyle(
                      fontSize: AppTypography.fontSize_sm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
