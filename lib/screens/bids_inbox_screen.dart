import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/models.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_widgets.dart';
import '../widgets/empty_state.dart';
import '../utils/toast_helper.dart';

class BidsInboxScreen extends StatefulWidget {
  final String city;
  final int budget;
  final int seats;
  final List<String> amenities;

  const BidsInboxScreen({
    Key? key,
    required this.city,
    required this.budget,
    required this.seats,
    required this.amenities,
  }) : super(key: key);

  @override
  State<BidsInboxScreen> createState() => _BidsInboxScreenState();
}

class _BidsInboxScreenState extends State<BidsInboxScreen> {
  bool _isAccepting = false;

  void _openBidModal(BidData bid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // StatefulBuilder so the sheet itself rebuilds when the accept spinner
      // toggles; the parent's setState doesn't reach a modal route.
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) =>
            _buildBidModal(bid, sheetContext, setSheetState),
      ),
    );
  }

  Widget _buildBidModal(
    BidData bid,
    BuildContext sheetContext,
    StateSetter setSheetState,
  ) {
    return BidModal(
      hostelName: bid.name,
      hostelRating: bid.rating.toString(),
      price: DummyData.formatPrice(bid.price),
      roomType: bid.roomType,
      amenities: bid.amenities.join(', '),
      distance: bid.distance,
      note: bid.note,
      isAccepting: _isAccepting,
      onDecline: () {
        Navigator.pop(sheetContext);
        ToastHelper.showInfo(
          context,
          message: 'Bid declined',
        );
      },
      onAccept: () async {
        setSheetState(() => _isAccepting = true);
        await Future.delayed(const Duration(milliseconds: 1000));
        _isAccepting = false;
        // The user may have dragged the sheet closed while waiting.
        if (!mounted || !sheetContext.mounted) return;
        Navigator.pop(sheetContext);

        {
          // Navigate to contact reveal screen
          Navigator.pushNamed(
            context,
            '/contact-reveal',
            arguments: {
              'hostelName': bid.name,
              'studentName': 'Ahmed Raza',
              'hostelPhone': bid.phone,
              'studentPhone': '0345-9876543',
              'hostelManager': bid.manager,
              'hostelEmail': bid.email,
              'studentEmail': 'ahmed.raza@email.com',
              'roomType': bid.roomType,
              'price': bid.price,
              'hostelAddress': bid.address,
              'hostelRating': bid.rating,
              'hostelAmenities': bid.amenities,
              'studentGender': 'Male',
              'studentLocation': '${widget.city} · ${widget.seats}-Seater',
            },
          );
        }
      },
    );
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
                title: 'Bids Inbox',
                onBackPressed: () => Navigator.pop(context),
                actionButton: GestureDetector(
                  onTap: () {
                    // Refresh logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bids refreshed')),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(AppRadius.full),
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.arrowsRotate,
                        color: AppColors.gray500,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Active Request Banner
                    ActiveRequestBanner(
                      summary:
                          '${widget.city} · ${DummyData.getRoomLabel(widget.seats)} · ${DummyData.formatPrice(widget.budget)}',
                      timeAgo: '3h ago',
                    ),

                    // Incoming Bids Header
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '📬 Incoming Bids',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppTypography.fontSize_base,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        Text(
                          '${DummyData.bids.length} new',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space3),

                    // Bid Cards or Empty State
                    if (DummyData.bids.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.space6,
                        ),
                        child: EmptyState(
                          icon: FontAwesomeIcons.inbox,
                          title: 'No Bids Yet',
                          description:
                              'Hostels will start bidding on your requirement once it\'s posted. Check back soon!',
                          buttonText: 'Post New Requirement',
                          onButtonTap: () =>
                              Navigator.pushNamed(context, '/post-requirement'),
                          iconColor: AppColors.navy,
                        ),
                      )
                    else ...[
                      ...DummyData.bids.map((bid) => BidCard(
                            hostelName: bid.name,
                            rating: bid.rating,
                            price: bid.price,
                            roomType: bid.roomType,
                            amenities: bid.amenities,
                            thumbnail: bid.thumbnail,
                            statusDot: bid.status,
                            onTap: () => _openBidModal(bid),
                          )),
                      const SizedBox(height: AppSpacing.space3),
                      Center(
                        child: Text(
                          '⏱️ Bids expire in 24 hours',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
