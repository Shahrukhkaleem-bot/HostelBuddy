import 'package:flutter/material.dart';
import '../models/complete_models.dart';
import 'hostel_form_screen.dart';
class EditHostelScreen extends StatelessWidget {
  final HostelData hostel;
  const EditHostelScreen({super.key, required this.hostel});
  @override
  Widget build(BuildContext context) => HostelFormScreen(hostel: hostel);
}
