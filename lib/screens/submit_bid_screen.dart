import 'package:flutter/material.dart';
import 'manager_post_bid_screen.dart';
class SubmitBidScreen extends StatelessWidget {
  final int requirementId;
  const SubmitBidScreen({super.key, required this.requirementId});
  @override
  Widget build(BuildContext context) => ManagerPostBidScreen(requirementId: requirementId);
}
