import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import 'app_button.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? actionButton;

  const PageHeader({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.gray100),
        ),
      ),
      child: Row(
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: onBackPressed ?? () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(AppRadius.full),
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
          if (showBackButton) const SizedBox(width: AppSpacing.space4),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ),
          if (actionButton != null) actionButton!,
          if (actionButton == null && showBackButton)
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class ActiveRequestBanner extends StatelessWidget {
  final String summary;
  final String timeAgo;

  const ActiveRequestBanner({
    Key? key,
    required this.summary,
    required this.timeAgo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ACTIVE REQUEST',
                  style: TextStyle(
                    fontSize: AppTypography.fontSize_xs,
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  summary,
                  style: const TextStyle(
                    fontSize: AppTypography.fontSize_base,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.15),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              '⏱️ $timeAgo',
              style: const TextStyle(
                fontSize: AppTypography.fontSize_xs,
                color: AppColors.white,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String number;
  final String label;

  const StatCard({
    Key? key,
    required this.number,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_2xl,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_xs,
              color: AppColors.gray500,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessOverlay extends StatefulWidget {
  final String title;
  final String subtitle;
  final Duration duration;
  final VoidCallback? onComplete;

  const SuccessOverlay({
    Key? key,
    required this.title,
    required this.subtitle,
    this.duration = const Duration(milliseconds: 2500),
    this.onComplete,
  }) : super(key: key);

  @override
  State<SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fadeController.forward();
    });

    Future.delayed(widget.duration, _close);
  }

  bool _closed = false;

  // Shared by the timer and tap-to-dismiss so the overlay pops once and
  // onComplete always runs exactly once.
  void _close() {
    if (_closed || !mounted) return;
    _closed = true;
    Navigator.of(context).pop();
    widget.onComplete?.call();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _close,
        child: Container(
          color: Color.fromRGBO(15, 27, 51, 0.60),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
                  ),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.green.withValues(alpha: 0.4),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: AppColors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                FadeTransition(
                  opacity: _fadeController,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: AppTypography.fontSize_xl,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space2),
                FadeTransition(
                  opacity: _fadeController,
                  child: Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: AppTypography.fontSize_base,
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      fontFamily: AppTypography.fontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BidModal extends StatelessWidget {
  final String hostelName;
  final String hostelRating;
  final String price;
  final String roomType;
  final String amenities;
  final String distance;
  final String note;
  final VoidCallback onDecline;
  final VoidCallback onAccept;
  final bool isAccepting;

  const BidModal({
    Key? key,
    required this.hostelName,
    required this.hostelRating,
    required this.price,
    required this.roomType,
    required this.amenities,
    required this.distance,
    required this.note,
    required this.onDecline,
    required this.onAccept,
    this.isAccepting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.xl),
              topRight: Radius.circular(AppRadius.xl),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.gray200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    hostelName,
                    style: const TextStyle(
                      fontSize: AppTypography.fontSize_lg,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    '⭐ $hostelRating · Near Sector',
                    style: const TextStyle(
                      fontSize: AppTypography.fontSize_sm,
                      color: AppColors.gray500,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  _DetailRow(label: 'Offered Price', value: price),
                  _DetailRow(label: 'Room Type', value: roomType),
                  _DetailRow(label: 'Amenities', value: amenities),
                  _DetailRow(label: 'Distance', value: distance),
                  const SizedBox(height: AppSpacing.space4),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.space4),
                    decoration: BoxDecoration(
                      color: AppColors.gray50,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: const Border(
                        left: BorderSide(
                          color: AppColors.green,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      '"$note"',
                      style: const TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        color: AppColors.gray700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Decline',
                          onPressed: onDecline,
                          variant: 'outline',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space3),
                      Expanded(
                        child: AppButton(
                          text: 'Accept',
                          onPressed: onAccept,
                          isLoading: isAccepting,
                          icon: FontAwesomeIcons.handshake,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space4),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_sm,
              color: AppColors.gray500,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_sm,
              fontWeight: FontWeight.w600,
              color: AppColors.gray900,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

