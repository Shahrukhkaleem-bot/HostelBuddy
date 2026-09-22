import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../widgets/app_button.dart';
import '../utils/toast_helper.dart';

class ManagerBidsScreen extends StatefulWidget {
  const ManagerBidsScreen({Key? key}) : super(key: key);

  @override
  State<ManagerBidsScreen> createState() => _ManagerBidsScreenState();
}

class SentBidData {
  final int id;
  final String studentName;
  final String roomType;
  final int price;
  final String status; // sent, pending, closed
  final DateTime date;
  final bool isAccepted;
  final String hostelName;

  SentBidData({
    required this.id,
    required this.studentName,
    required this.roomType,
    required this.price,
    required this.status,
    required this.date,
    required this.isAccepted,
    required this.hostelName,
  });
}

class _ManagerBidsScreenState extends State<ManagerBidsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<SentBidData> allBids;

  // Wallet/Coins
  int managerCoins = 8000;
  static const int POST_BID_COIN_COST = 50;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize dummy data
    allBids = [
      // Sent bids
      SentBidData(
        id: 1,
        studentName: 'Ahmed Raza',
        roomType: '2-Seater',
        price: 25000,
        status: 'sent',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isAccepted: false,
        hostelName: 'Al-Haram Hostel',
      ),
      SentBidData(
        id: 2,
        studentName: 'Sana Khan',
        roomType: '1-Seater',
        price: 20000,
        status: 'sent',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isAccepted: false,
        hostelName: 'Al-Haram Hostel',
      ),
      SentBidData(
        id: 3,
        studentName: 'Ali Hassan',
        roomType: '3-Seater',
        price: 30000,
        status: 'sent',
        date: DateTime.now(),
        isAccepted: false,
        hostelName: 'Al-Haram Hostel',
      ),
      // Pending bids (student reviewing)
      SentBidData(
        id: 4,
        studentName: 'Fatima Ali',
        roomType: '2-Seater',
        price: 28000,
        status: 'pending',
        date: DateTime.now().subtract(const Duration(days: 3)),
        isAccepted: false,
        hostelName: 'Al-Haram Hostel',
      ),
      // Closed bids (accepted)
      SentBidData(
        id: 5,
        studentName: 'Muhammad Bilal',
        roomType: '1-Seater',
        price: 22000,
        status: 'closed',
        date: DateTime.now().subtract(const Duration(days: 5)),
        isAccepted: true,
        hostelName: 'Al-Haram Hostel',
      ),
      // Closed bids (rejected)
      SentBidData(
        id: 6,
        studentName: 'Zainab Ahmed',
        roomType: '2-Seater',
        price: 15000,
        status: 'closed',
        date: DateTime.now().subtract(const Duration(days: 4)),
        isAccepted: false,
        hostelName: 'Al-Haram Hostel',
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SentBidData> getFilteredBids(String status) {
    return allBids.where((bid) => bid.status == status).toList();
  }

  void withdrawBid(SentBidData bid) {
    setState(() {
      final index = allBids.indexWhere((b) => b.id == bid.id);
      if (index != -1) {
        allBids.removeAt(index);
        // Refund coins when withdrawing
        managerCoins += POST_BID_COIN_COST;
      }
    });
    ToastHelper.showSuccess(
      context,
      message: 'Bid withdrawn | +${POST_BID_COIN_COST} coins refunded',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('My Bids'),
        actions: [
          Container(
            margin: const EdgeInsets.all(AppSpacing.space3),
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
              children: [
                const Icon(FontAwesomeIcons.coins,
                    size: 16, color: AppColors.green),
                const SizedBox(width: 6),
                Text(
                  '$managerCoins',
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
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.green,
          unselectedLabelColor: AppColors.gray500,
          indicatorColor: AppColors.green,
          tabs: const [
            Tab(text: 'Sent'),
            Tab(text: 'Pending'),
            Tab(text: 'Closed'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/manager-post-bid');
        },
        backgroundColor: AppColors.green,
        icon: const Icon(FontAwesomeIcons.plus),
        label: const Text('Post Bid'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBidsList('sent'),
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
                            bid.studentName,
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_base,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bid.hostelName,
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
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: status == 'closed'
                            ? (bid.isAccepted
                                ? AppColors.greenBg
                                : AppColors.error.withValues(alpha: 0.1))
                            : (status == 'pending'
                                ? AppColors.infoLight
                                : AppColors.gray100),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        status == 'closed'
                            ? (bid.isAccepted ? 'Accepted' : 'Rejected')
                            : (status == 'pending' ? 'Reviewing' : 'Waiting'),
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_xs,
                          fontWeight: FontWeight.w600,
                          color: status == 'closed'
                              ? (bid.isAccepted
                                  ? AppColors.green
                                  : AppColors.error)
                              : (status == 'pending'
                                  ? AppColors.info
                                  : AppColors.gray500),
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
                          'Bid Price',
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
                if (status == 'sent')
                  AppButton(
                    text: 'Withdraw Bid',
                    onPressed: () => withdrawBid(bid),
                    variant: 'outline',
                    icon: FontAwesomeIcons.xmark,
                  )
                else if (status == 'pending')
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.space2),
                    decoration: BoxDecoration(
                      color: AppColors.infoLight,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        const Icon(FontAwesomeIcons.circleInfo,
                            color: AppColors.info, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Student is reviewing your bid',
                            style: const TextStyle(
                              fontSize: AppTypography.fontSize_xs,
                              color: AppColors.info,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (status == 'closed' && bid.isAccepted)
                  AppButton(
                    text: 'Review Student',
                    onPressed: () {
                      ToastHelper.showInfo(context,
                          message: 'Review feature coming soon');
                    },
                    icon: FontAwesomeIcons.star,
                  )
                else if (status == 'closed' && !bid.isAccepted)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.space2),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.xmark,
                            color: AppColors.error, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Student rejected this bid',
                            style: TextStyle(
                              fontSize: AppTypography.fontSize_xs,
                              color: AppColors.error,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
