import 'package:flutter/material.dart';
import 'student_quotes_screen.dart';
class ManagerBidsScreen extends StatelessWidget {
  const ManagerBidsScreen({super.key});
  @override
  Widget build(BuildContext context) => const StudentQuotesScreen(manager: true);
}
