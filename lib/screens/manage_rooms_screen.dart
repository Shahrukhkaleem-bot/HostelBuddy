import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_store.dart';
import '../core/hostel_search.dart';
import '../models/complete_models.dart';
import '../widgets/marketplace_widgets.dart';

class ManageRoomsScreen extends StatelessWidget {
  final HostelData hostel;
  const ManageRoomsScreen({super.key, required this.hostel});

  Future<void> editRoom(BuildContext context, RoomData? room) async {
    final result = await showDialog<RoomData>(context: context,
      builder: (_) => _RoomEditor(room: room));
    if (result == null || !context.mounted) return;
    final store = AppStore.instance;
    final current = store.hostel(hostel.id);
    if (current == null) return;
    final rooms = [...current.rooms];
    final index = rooms.indexWhere((r) => r.id == result.id);
    if (index < 0) { rooms.add(result); } else { rooms[index] = result; }
    store.saveRooms(hostel.id, rooms);
    showMessage(context, 'Room saved locally');
  }

  @override
  Widget build(BuildContext context) => StoreBuilder(builder: (context, store) {
    final current = store.hostel(hostel.id);
    if (current == null) return const UnavailableScreen();
    return Scaffold(
      appBar: AppBar(title: const Text('Manage rooms')),
      body: PageBody(children: [
        Text(current.name, style: Theme.of(context).textTheme.titleLarge),
        Text('${current.rooms.length} rooms • ${current.rooms.fold<int>(0, (n, r) => n + r.availableBeds)} available beds'),
        const SizedBox(height: 12), const DemoNotice(),
        if (current.rooms.isEmpty) const Padding(padding: EdgeInsets.all(16),
          child: Text('No rooms yet. Add the first room below.')),
        ...current.rooms.map((room) => SectionCard(child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('Room #${room.id} • ${room.type}', style: Theme.of(context).textTheme.titleMedium),
            Text('${money(room.pricePerBed)} / bed / month'),
            Row(children: [
              Expanded(child: Text('${room.availableBeds} available of ${room.capacity} beds')),
              IconButton(tooltip: 'Reduce availability', onPressed: room.availableBeds == 0 ? null :
                () => _availability(store, current, room, room.availableBeds - 1), icon: const Icon(Icons.remove)),
              IconButton(tooltip: 'Increase availability', onPressed: room.availableBeds >= room.capacity ? null :
                () => _availability(store, current, room, room.availableBeds + 1), icon: const Icon(Icons.add)),
            ]),
            Wrap(spacing: 8, children: [
              OutlinedButton.icon(onPressed: () => editRoom(context, room),
                icon: const Icon(Icons.edit), label: const Text('Edit room')),
              TextButton.icon(onPressed: () async {
                if (!await confirmAction(context, 'Delete room?', 'This removes the room from the local hostel inventory.', action: 'Delete')) return;
                if (!context.mounted) return;
                final error = store.deleteRoom(hostel.id, room.id);
                showMessage(context, error ?? 'Room deleted');
              }, icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
            ]),
          ]))),
        FilledButton.icon(onPressed: () => editRoom(context, null),
          icon: const Icon(Icons.add), label: const Text('Add room')),
      ]),
    );
  });
  void _availability(AppStore store, HostelData current, RoomData room, int available) {
    store.saveRooms(current.id, current.rooms.map((r) => r.id != room.id ? r : RoomData(
      id: r.id, type: r.type, capacity: r.capacity, pricePerBed: r.pricePerBed,
      availableBeds: available.clamp(0, r.capacity), amenities: r.amenities, imageUrl: r.imageUrl)).toList());
  }
}

class _RoomEditor extends StatefulWidget {
  final RoomData? room;
  const _RoomEditor({this.room});
  @override
  State<_RoomEditor> createState() => _RoomEditorState();
}
class _RoomEditorState extends State<_RoomEditor> {
  final form = GlobalKey<FormState>();
  late final TextEditingController price;
  late int capacity;
  late int available;
  late Set<String> amenities;
  @override
  void initState() {
    super.initState();
    capacity = (widget.room?.capacity ?? 2).clamp(1, 4);
    available = (widget.room?.availableBeds ?? capacity).clamp(0, capacity);
    price = TextEditingController(text: widget.room?.pricePerBed.toString() ?? '');
    amenities = {...?widget.room?.amenities};
  }
  @override
  void dispose() { price.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.room == null ? 'Add room' : 'Edit room'),
    scrollable: true,
    content: SizedBox(width: 420, child: Form(key: form, child: Column(mainAxisSize: MainAxisSize.min, children: [
      DropdownButtonFormField<int>(initialValue: capacity,
        decoration: const InputDecoration(labelText: 'Beds in this room'),
        items: [1, 2, 3, 4].map((n) => DropdownMenuItem(value: n, child: Text('$n-Seater'))).toList(),
        onChanged: (v) { if (v != null) setState(() { capacity = v; available = available.clamp(0, v); }); }),
      const SizedBox(height: 16),
      TextFormField(controller: price, keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: priceValidator, decoration: const InputDecoration(labelText: 'Price per bed / month (PKR)')),
      const SizedBox(height: 16),
      DropdownButtonFormField<int>(key: ValueKey('available-$capacity-$available'),
        initialValue: available, decoration: const InputDecoration(labelText: 'Available beds'),
        items: List.generate(capacity + 1, (n) => DropdownMenuItem(value: n, child: Text('$n'))),
        onChanged: (v) { if (v != null) setState(() => available = v); }),
      const SizedBox(height: 12),
      Wrap(spacing: 6, children: amenityOptions.map((a) => FilterChip(label: Text(a),
        selected: amenities.contains(a), onSelected: (v) => setState(() {
          if (v) { amenities.add(a); } else { amenities.remove(a); }
        }))).toList()),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      FilledButton(onPressed: () {
        if (!form.currentState!.validate()) return;
        Navigator.pop(context, RoomData(id: widget.room?.id ?? AppStore.instance.newId(),
          type: '$capacity-Seater', capacity: capacity, pricePerBed: int.parse(price.text.trim()),
          availableBeds: available, amenities: amenities.toList(), imageUrl: ''));
      }, child: const Text('Save')),
    ],
  );
}
