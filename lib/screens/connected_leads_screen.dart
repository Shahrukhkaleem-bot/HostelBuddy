import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/models.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_widgets.dart';

class ConnectedLeadsScreen extends StatelessWidget {
  const ConnectedLeadsScreen({Key? key}) : super(key: key);

  void _openWhatsApp(BuildContext context, String phone) {
    // In a real app, this would open WhatsApp
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening WhatsApp with $phone'),
      ),
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
                title: 'Connected Leads',
                onBackPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Leads Header
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            '📖 Accepted Students',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppTypography.fontSize_base,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                        ),
                        Text(
                          '${DummyData.leads.length} contacts',
                          style: const TextStyle(
                            fontSize: AppTypography.fontSize_xs,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space3),

                    // Leads List
                    ...DummyData.leads.map((lead) => LeadItem(
                          name: lead.name,
                          phone: lead.phone,
                          avatar: lead.avatar,
                          onWhatsAppTap: () =>
                              _openWhatsApp(context, lead.phone),
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/hostel-review',
                            arguments: {
                              'studentName': lead.name,
                              'hostelName': lead.hostel,
                            },
                          ),
                        )),

                    const SizedBox(height: AppSpacing.space3),

                    // Info Box
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius:
                            BorderRadius.circular(AppRadius.md),
                      ),
                      padding:
                          const EdgeInsets.all(AppSpacing.space4),
                      child: const Center(
                        child: Text(
                          '☎️ Phone numbers are unmasked after acceptance\nTap a student to leave a review',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppTypography.fontSize_sm,
                            color: AppColors.gray500,
                            fontFamily: AppTypography.fontFamily,
                          ),
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
