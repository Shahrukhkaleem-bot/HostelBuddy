import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/complete_models.dart';
import '../models/models.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  final HostelData hostel;

  const AnalyticsDashboardScreen({Key? key, required this.hostel})
      : super(key: key);

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  String selectedPeriod = 'month'; // week, month, quarter, year

  // Sample analytics data
  int totalBookings = 145;
  int confirmedBookings = 128;
  int pendingBookings = 12;
  int cancelledBookings = 5;
  double occupancyRate = 87.5;
  late double avgRating;
  double revenue = 385000;
  double avgRevenuePerMonth = 128000;

  @override
  void initState() {
    super.initState();
    avgRating = widget.hostel.overallRating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Analytics Dashboard'),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(FontAwesomeIcons.chevronLeft, color: AppColors.navy),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
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
              child: Row(
                children: const [
                  Icon(FontAwesomeIcons.calendar, size: 16, color: AppColors.green),
                  SizedBox(width: AppSpacing.space2),
                  Expanded(
                    child: Text(
                      'Last 30 Days',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_sm,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ),
                  Icon(FontAwesomeIcons.chevronDown, size: 14, color: AppColors.gray500),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // KPI Cards
            const Text(
              'Key Performance Indicators',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            // Row 1: Revenue & Occupancy
            Row(
              children: [
                Expanded(
                  child: _KPICard(
                    icon: FontAwesomeIcons.moneyBill,
                    title: 'Revenue',
                    value: DummyData.formatPrice(avgRevenuePerMonth.round()),
                    subtitle: 'This month',
                    color: AppColors.green,
                    trend: '+12%',
                    trendPositive: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: _KPICard(
                    icon: FontAwesomeIcons.chartBar,
                    title: 'Occupancy',
                    value: '${occupancyRate.toStringAsFixed(1)}%',
                    subtitle: 'Current rate',
                    color: AppColors.info,
                    trend: '+5%',
                    trendPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space3),

            // Row 2: Rating & Bookings
            Row(
              children: [
                Expanded(
                  child: _KPICard(
                    icon: FontAwesomeIcons.star,
                    title: 'Rating',
                    value: widget.hostel.overallRating.toStringAsFixed(1),
                    subtitle: 'Guest rating',
                    color: AppColors.warning,
                    trend: '+0.2',
                    trendPositive: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: _KPICard(
                    icon: FontAwesomeIcons.calendarCheck,
                    title: 'Bookings',
                    value: '$confirmedBookings',
                    subtitle: 'Confirmed',
                    color: AppColors.green,
                    trend: '+8',
                    trendPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space6),

            // Booking Status Section
            const Text(
              'Booking Status',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            Container(
              padding: const EdgeInsets.all(AppSpacing.space4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray100),
              ),
              child: Column(
                children: [
                  _BookingStatusRow(
                    label: 'Confirmed',
                    count: confirmedBookings,
                    total: totalBookings,
                    color: AppColors.green,
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  _BookingStatusRow(
                    label: 'Pending',
                    count: pendingBookings,
                    total: totalBookings,
                    color: AppColors.warning,
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  _BookingStatusRow(
                    label: 'Cancelled',
                    count: cancelledBookings,
                    total: totalBookings,
                    color: AppColors.error,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Revenue Breakdown
            const Text(
              'Revenue Breakdown',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            Container(
              padding: const EdgeInsets.all(AppSpacing.space4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray100),
              ),
              child: Column(
                children: [
                  _RevenueItem(
                    label: '1-Seater Rooms',
                    amount: 45000,
                    percentage: 35,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  _RevenueItem(
                    label: '2-Seater Rooms',
                    amount: 52000,
                    percentage: 40,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  _RevenueItem(
                    label: '3-Seater Rooms',
                    amount: 31000,
                    percentage: 25,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Divider(
                    height: 1,
                    color: AppColors.gray200,
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Revenue',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_base,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      Text(
                        DummyData.formatPrice(revenue.round()),
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_lg,
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
            const SizedBox(height: AppSpacing.space6),

            // Quick Stats
            const Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: AppTypography.fontSize_lg,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),

            Container(
              padding: const EdgeInsets.all(AppSpacing.space4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.gray100),
              ),
              child: Column(
                children: [
                  _QuickStatRow(
                    icon: FontAwesomeIcons.users,
                    label: 'Average Occupancy',
                    value: '${(occupancyRate * 0.95).toStringAsFixed(1)}%',
                    detail: 'Last week',
                  ),
                  const Divider(height: 20, color: AppColors.gray100),
                  _QuickStatRow(
                    icon: FontAwesomeIcons.commentDots,
                    label: 'Total Reviews',
                    value: '${widget.hostel.totalReviews}',
                    detail: 'Guest feedback',
                  ),
                  const Divider(height: 20, color: AppColors.gray100),
                  _QuickStatRow(
                    icon: FontAwesomeIcons.circleCheck,
                    label: 'Success Rate',
                    value: '${((confirmedBookings / totalBookings) * 100).toStringAsFixed(1)}%',
                    detail: 'Booking completion',
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

class _KPICard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final String trend;
  final bool trendPositive;

  const _KPICard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.trend,
    required this.trendPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 20),
            ),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_xs,
              color: AppColors.gray500,
              fontWeight: FontWeight.w500,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppTypography.fontSize_lg,
              fontWeight: FontWeight.w700,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_xs,
                  color: AppColors.gray500,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: trendPositive
                      ? AppColors.greenBg
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    fontSize: AppTypography.fontSize_xs,
                    fontWeight: FontWeight.w600,
                    color: trendPositive ? AppColors.green : AppColors.error,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingStatusRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _BookingStatusRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (count / total) * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: AppTypography.fontSize_sm,
                fontWeight: FontWeight.w600,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            Text(
              '$count (${ percentage.toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: AppTypography.fontSize_sm,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: LinearProgressIndicator(
            value: count / total,
            minHeight: 8,
            backgroundColor: AppColors.gray200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _RevenueItem extends StatelessWidget {
  final String label;
  final int amount;
  final int percentage;

  const _RevenueItem({
    required this.label,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: AppTypography.fontSize_sm,
                fontWeight: FontWeight.w600,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            Text(
              DummyData.formatPrice(amount),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: AppColors.gray200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
          ),
        ),
      ],
    );
  }
}

class _QuickStatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String detail;

  const _QuickStatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.greenBg,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Center(
            child: Icon(icon, color: AppColors.green, size: 18),
          ),
        ),
        const SizedBox(width: AppSpacing.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_sm,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: AppTypography.fontSize_xs,
                  color: AppColors.gray500,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppTypography.fontSize_lg,
            fontWeight: FontWeight.w700,
            color: AppColors.green,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
      ],
    );
  }
}
