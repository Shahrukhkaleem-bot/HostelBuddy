import 'package:flutter/material.dart';
import 'student_quotes_screen.dart';
class BidsInboxScreen extends StatelessWidget {
  final int requirementId;
  const BidsInboxScreen({super.key, required this.requirementId});
  @override
  Widget build(BuildContext context) => StudentQuotesScreen(requirementId: requirementId);
}
