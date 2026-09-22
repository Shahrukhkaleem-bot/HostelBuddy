import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
import '../models/complete_models.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';
import '../utils/toast_helper.dart';

class ManageRoomsScreen extends StatefulWidget {
  final HostelData hostel;

  const ManageRoomsScreen({Key? key, required this.hostel}) : super(key: key);

  @override
  State<ManageRoomsScreen> createState() => _ManageRoomsScreenState();
}

class _ManageRoomsScreenState extends State<ManageRoomsScreen> {
  late List<RoomData> rooms;
  bool showAddForm = false;

  // Add room form controllers
  final roomTypeController = TextEditingController();
  final capacityController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    rooms = List.from(widget.hostel.rooms);
  }

  @override
  void dispose() {
    roomTypeController.dispose();
    capacityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void addRoom() {
    if (roomTypeController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter room type');
      return;
    }
    if (capacityController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter room capacity');
      return;
    }
    if (priceController.text.isEmpty) {
      ToastHelper.showError(context, message: 'Please enter room price');
      return;
    }

    final capacity = int.tryParse(capacityController.text.trim());
    if (capacity == null || capacity < 1) {
      ToastHelper.showError(context, message: 'Capacity must be a number of at least 1');
      return;
    }
    final price = int.tryParse(priceController.text.trim());
    if (price == null || price < 1) {
      ToastHelper.showError(context, message: 'Price must be a positive number');
      return;
    }
    // Next id after the highest existing one; rooms.length repeats after deletes.
    final nextId = rooms.fold<int>(0, (maxId, room) => room.id > maxId ? room.id : maxId) + 1;

    final newRoom = RoomData(
      id: nextId,
      type: roomTypeController.text,
      capacity: capacity,
      pricePerBed: price,
      availableBeds: capacity,
      amenities: [],
      imageUrl: '🛏️',
    );

    setState(() {
      rooms.add(newRoom);
      showAddForm = false;
      roomTypeController.clear();
      capacityController.clear();
      priceController.clear();
    });

    ToastHelper.showSuccess(context, message: 'Room added successfully!');
  }

  void deleteRoom(int index) {
    setState(() => rooms.removeAt(index));
    ToastHelper.showSuccess(context, message: 'Room deleted');
  }

  void updateRoomAvailability(int index, int available) {
    setState(() {
      rooms[index] = RoomData(
        id: rooms[index].id,
        type: rooms[index].type,
        capacity: rooms[index].capacity,
        pricePerBed: rooms[index].pricePerBed,
        availableBeds: available,
        amenities: rooms[index].amenities,
        imageUrl: rooms[index].imageUrl,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Manage Rooms'),
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
            // Header with stats
            Container(
              padding: const EdgeInsets.all(AppSpacing.space3),
              decoration: BoxDecoration(
                color: AppColors.greenBg,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.green),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Room Management',
                        style: TextStyle(
                          fontSize: AppTypography.fontSize_sm,
                          fontWeight: FontWeight.w500,
                          color: AppColors.green,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${rooms.length} rooms • ${rooms.fold<int>(0, (sum, room) => sum + room.availableBeds)} available',
                        style: const TextStyle(
                          fontSize: AppTypography.fontSize_base,
                          fontWeight: FontWeight.w700,
                          color: AppColors.green,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.space2),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.bed,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Rooms List
            if (rooms.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.space6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.ban,
                      size: 40,
                      color: AppColors.gray300,
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    const Text(
                      'No Rooms Added Yet',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_base,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray500,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.space3),
                    padding: const EdgeInsets.all(AppSpacing.space3),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.gray100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Room Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.type,
                                  style: const TextStyle(
                                    fontSize: AppTypography.fontSize_base,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.users,
                                      size: 12,
                                      color: AppColors.gray500,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${room.capacity} seater',
                                      style: const TextStyle(
                                        fontSize: AppTypography.fontSize_xs,
                                        color: AppColors.gray500,
                                        fontFamily: AppTypography.fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => deleteRoom(index),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppRadius.full),
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.trash,
                                  size: 14,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.space3),

                        // Price and Availability Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Price per Bed',
                                  style: TextStyle(
                                    fontSize: AppTypography.fontSize_xs,
                                    color: AppColors.gray500,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₨${room.pricePerBed}',
                                  style: const TextStyle(
                                    fontSize: AppTypography.fontSize_lg,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.green,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Available',
                                  style: TextStyle(
                                    fontSize: AppTypography.fontSize_xs,
                                    color: AppColors.gray500,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.space3,
                                    vertical: AppSpacing.space2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: room.availableBeds > 0
                                        ? AppColors.greenBg
                                        : AppColors.error.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                  ),
                                  child: Text(
                                    '${room.availableBeds} beds',
                                    style: TextStyle(
                                      fontSize: AppTypography.fontSize_sm,
                                      fontWeight: FontWeight.w600,
                                      color: room.availableBeds > 0
                                          ? AppColors.green
                                          : AppColors.error,
                                      fontFamily: AppTypography.fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.space3),

                        // Availability Controls
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Adjust Availability',
                                style: const TextStyle(
                                  fontSize: AppTypography.fontSize_xs,
                                  color: AppColors.gray500,
                                  fontFamily: AppTypography.fontFamily,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (room.availableBeds > 0) {
                                  updateRoomAvailability(index, room.availableBeds - 1);
                                }
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.gray100,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: const Center(
                                  child: Icon(FontAwesomeIcons.minus,
                                      size: 12, color: AppColors.navy),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.space2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.space3,
                              ),
                              child: Text(
                                '${room.availableBeds}',
                                style: const TextStyle(
                                  fontSize: AppTypography.fontSize_base,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppTypography.fontFamily,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.space2),
                            GestureDetector(
                              onTap: () {
                                updateRoomAvailability(index, room.availableBeds + 1);
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: const Center(
                                  child: Icon(FontAwesomeIcons.plus,
                                      size: 12, color: AppColors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: AppSpacing.space6),

            // Add Room Form
            if (!showAddForm)
              AppButton(
                text: 'Add New Room',
                onPressed: () => setState(() => showAddForm = true),
                icon: FontAwesomeIcons.plus,
              )
            else
              Container(
                padding: const EdgeInsets.all(AppSpacing.space4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.green, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Room',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize_lg,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    AppInputField(
                      label: 'Room Type',
                      placeholder: 'e.g., 2-Seater, 3-Seater',
                      controller: roomTypeController,
                      prefixIcon: FontAwesomeIcons.bed,
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    AppInputField(
                      label: 'Capacity',
                      placeholder: 'Number of beds',
                      controller: capacityController,
                      prefixIcon: FontAwesomeIcons.users,
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    AppInputField(
                      label: 'Price per Bed',
                      placeholder: 'Enter price (₨)',
                      controller: priceController,
                      prefixIcon: FontAwesomeIcons.moneyBill,
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Add Room',
                            onPressed: addRoom,
                            icon: FontAwesomeIcons.check,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.space3),
                        Expanded(
                          child: AppButton(
                            text: 'Cancel',
                            onPressed: () => setState(() => showAddForm = false),
                            variant: 'outline',
                            icon: FontAwesomeIcons.xmark,
                          ),
                        ),
                      ],
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
