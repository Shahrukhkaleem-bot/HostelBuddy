import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/models.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_widgets.dart';

class WardenDashboardScreen extends StatefulWidget {
  const WardenDashboardScreen({Key? key}) : super(key: key);

  @override
  State<WardenDashboardScreen> createState() =>
      _WardenDashboardScreenState();
}

class _WardenDashboardScreenState extends State<WardenDashboardScreen> {
  bool isLoadingMatches = false;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  void _loadMatches() async {
    setState(() => isLoadingMatches = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => isLoadingMatches = false);
    }
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
                title: '🏨 HostelBuddy',
                showBackButton: false,
                actionButton: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(AppRadius.full),
                  ),
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.bell,
                      color: AppColors.gray500,
                      size: 18,
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
                    // Stats
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            number: '12',
                            label: 'Active Vacancies',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.space3),
                        Expanded(
                          child: StatCard(
                            number: '8',
                            label: 'System Matches',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space4),

                    // Matches Header
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '👥 System Matches',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppTypography.fontSize_base,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                        Text(
                          isLoadingMatches ? 'Loading...' : 'AI-matched',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space3),

                    // Skeleton Loading or Matches
                    if (isLoadingMatches)
                      Column(
                        children: List.generate(3, (_) => _buildSkeleton()),
                      )
                    else
                      Column(
                        children: DummyData.matches
                            .map((match) => MatchCard(
                                  studentId: match.studentId,
                                  gender: match.gender,
                                  city: match.city,
                                  budget: match.budget,
                                  roomType: match.roomType,
                                  amenities: match.amenities,
                                  matchScore: match.matchScore,
                                  onBidNow: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/submit-bid',
                                      arguments: {
                                        'studentId': match.studentId,
                                        'city': match.city,
                                        'budget': match.budget,
                                      },
                                    );
                                  },
                                ))
                            .toList(),
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

  Widget _buildSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const SizedBox(height: AppSpacing.space2),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ],
      ),
    );
  }
}
