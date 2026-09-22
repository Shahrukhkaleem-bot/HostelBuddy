import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';

class ResidentHomeScreen extends StatelessWidget {
  const ResidentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            // Compact Header Section
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space4,
                vertical: AppSpacing.space4,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.green,
                    AppColors.green.withValues(alpha: 0.85),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.green.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Ali Hassan',
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_lg,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/user-profile'),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          FontAwesomeIcons.user,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recent Requirements Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recent Requests',
                              style: TextStyle(
                                fontSize: AppTypography.fontSize_lg,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                                fontFamily: AppTypography.fontFamily,
                                letterSpacing: -0.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successLight,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.circle,
                                    size: 6,
                                    color: AppColors.successMain,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '2 active requests',
                                    style: TextStyle(
                                      fontSize: AppTypography.fontSize_xs,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.successMain,
                                      fontFamily: AppTypography.fontFamily,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/bids-inbox', arguments: {
                              'city': 'G-11, Islamabad',
                              'budget': 35000,
                              'seats': 1,
                              'amenities': ['ups', 'wifi'],
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.green.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  'View all',
                                  style: TextStyle(
                                    fontSize: AppTypography.fontSize_sm,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.green,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  FontAwesomeIcons.chevronRight,
                                  size: 14,
                                  color: AppColors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Recent Requirement Card
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/bids-inbox', arguments: {
                          'city': 'G-11, Islamabad',
                          'budget': 35000,
                          'seats': 1,
                          'amenities': ['ups', 'wifi'],
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(
                            color: AppColors.green,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.green.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(AppSpacing.space4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status and Price Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.green,
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Active',
                                      style: TextStyle(
                                        fontSize: AppTypography.fontSize_sm,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.green,
                                        fontFamily: AppTypography.fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.green.withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.full),
                                  ),
                                  child: const Text(
                                    'PKR 35K',
                                    style: TextStyle(
                                      fontSize: AppTypography.fontSize_sm,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.green,
                                      fontFamily: AppTypography.fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.space3),

                            // Location
                            Row(
                              children: const [
                                Icon(
                                  FontAwesomeIcons.mapPin,
                                  size: 14,
                                  color: AppColors.gray700,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'G-11, Islamabad',
                                  style: TextStyle(
                                    fontSize: AppTypography.fontSize_base,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.navy,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.space3),

                            // Details Row
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.bed,
                                      size: 12,
                                      color: AppColors.gray500,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '1-Seater',
                                      style: TextStyle(
                                        fontSize: AppTypography.fontSize_sm,
                                        color: AppColors.gray700,
                                        fontFamily: AppTypography.fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.clock,
                                      size: 12,
                                      color: AppColors.gray500,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '3h ago',
                                      style: TextStyle(
                                        fontSize: AppTypography.fontSize_sm,
                                        color: AppColors.gray500,
                                        fontFamily: AppTypography.fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.infoLight,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.full),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.commentDots,
                                        size: 11,
                                        color: AppColors.infoMain,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '4 bids',
                                        style: TextStyle(
                                          fontSize: AppTypography.fontSize_xs,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.infoMain,
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
}
