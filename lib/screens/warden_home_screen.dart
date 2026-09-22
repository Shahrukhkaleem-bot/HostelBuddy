import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../widgets/app_button.dart';

class WardenHomeScreen extends StatelessWidget {
  const WardenHomeScreen({Key? key}) : super(key: key);

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
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.gray100),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hostel Manager',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_lg,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Green Valley Hostel',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          color: AppColors.gray500,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.hotel,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Stats
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.all(AppSpacing.space4),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                  color: AppColors.gray100),
                            ),
                            child: Column(
                              children: const [
                                Icon(
                                  FontAwesomeIcons.doorOpen,
                                  color: AppColors.navy,
                                  size: 24,
                                ),
                                SizedBox(height: AppSpacing.space2),
                                Text(
                                  '12',
                                  style: TextStyle(
                                    fontSize:
                                        AppTypography.fontSize_2xl,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                    fontFamily: AppTypography
                                        .fontFamily,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Vacancies',
                                  style: TextStyle(
                                    fontSize: AppTypography.fontSize_xs,
                                    color: AppColors.gray500,
                                    fontFamily: AppTypography
                                        .fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.space3),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.all(AppSpacing.space4),
                            decoration: BoxDecoration(
                              color: AppColors.greenBg,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                  color: AppColors.green),
                            ),
                            child: Column(
                              children: const [
                                Icon(
                                  FontAwesomeIcons.users,
                                  color: AppColors.green,
                                  size: 24,
                                ),
                                SizedBox(height: AppSpacing.space2),
                                Text(
                                  '8',
                                  style: TextStyle(
                                    fontSize:
                                        AppTypography.fontSize_2xl,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.green,
                                    fontFamily: AppTypography
                                        .fontFamily,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Matches',
                                  style: TextStyle(
                                    fontSize: AppTypography.fontSize_xs,
                                    color: AppColors.greenDark,
                                    fontFamily: AppTypography
                                        .fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space5),

                    // Action Buttons
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'View Dashboard',
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/warden-dashboard',
                        ),
                        icon: FontAwesomeIcons.chartLine,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Connected Leads',
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/connected-leads',
                        ),
                        variant: 'outline',
                        icon: FontAwesomeIcons.phoneVolume,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space5),

                    // Recent Bids
                    const Text(
                      'Recent Bids Submitted',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    Container(
                      padding:
                          const EdgeInsets.all(AppSpacing.space4),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.gray100),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'HB-2049 (2-Seater)',
                                style: TextStyle(
                                  fontSize: AppTypography.fontSize_sm,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.gray900,
                                  fontFamily: AppTypography
                                      .fontFamily,
                                ),
                              ),
                              Text(
                                'PKR 38,000',
                                style: TextStyle(
                                  fontSize: AppTypography.fontSize_sm,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.green,
                                  fontFamily: AppTypography
                                      .fontFamily,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.space2),
                          Row(
                            children: const [
                              Icon(
                                FontAwesomeIcons.clock,
                                size: 12,
                                color: AppColors.gray500,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Submitted 2 hours ago',
                                style: TextStyle(
                                  fontSize: AppTypography.fontSize_xs,
                                  color: AppColors.gray500,
                                  fontFamily: AppTypography
                                      .fontFamily,
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
            ),
          ],
        ),
      ),
    );
  }
}
