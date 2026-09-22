import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_store.dart';
import '../core/hostel_search.dart';
import '../widgets/marketplace_widgets.dart';

class ManagerPostBidScreen extends StatefulWidget {
  final int? requirementId;
  const ManagerPostBidScreen({super.key, this.requirementId});
  @override
  State<ManagerPostBidScreen> createState() => _ManagerPostBidScreenState();
}
class _ManagerPostBidScreenState extends State<ManagerPostBidScreen> {
  final form = GlobalKey<FormState>();
  final price = TextEditingController();
  final note = TextEditingController();
  int? requirementId;
  int? roomId;
  bool submitted = false;
  @override
  void initState() { super.initState(); requirementId = widget.requirementId; }
  @override
  void dispose() { price.dispose(); note.dispose(); super.dispose(); }
  void submit() {
    if (submitted || !form.currentState!.validate()) return;
    final store = AppStore.instance;
    if (requirementId == null || roomId == null || store.selectedHostelId == null) {
      showMessage(context, 'Choose a request and an available room.'); return;
    }
    final error = store.postBid(requirementId: requirementId!, hostelId: store.selectedHostelId!,
      roomId: roomId!, price: int.parse(price.text.trim()), note: note.text);
    if (error != null) { showMessage(context, error); return; }
    submitted = true;
    showMessage(context, 'Demo offer posted. 50 demo coins deducted.');
    Navigator.pop(context, true);
  }
  @override
  Widget build(BuildContext context) => StoreBuilder(builder: (context, store) {
    final hostel = store.selectedHostel;
    if (hostel == null) return const UnavailableScreen(message: 'Register or select a hostel first.');
    final request = store.requirement(requirementId);
    final rooms = hostel.rooms.where((r) => r.availableBeds > 0 && (request == null || r.type == request.roomType)).toList();
    final requests = store.requirements;
    return Scaffold(appBar: AppBar(title: const Text('Post an offer')),
      body: Form(key: form, child: PageBody(children: [
        const DemoNotice(),
        Text(hostel.name, style: Theme.of(context).textTheme.titleLarge),
        Text('${store.managerCoins} demo coins • Posting costs 50'),
        const SizedBox(height: 16),
        if (requests.isEmpty) const Text('No requests yet. Create one in the student demo first.')
        else DropdownButtonFormField<int>(initialValue: request?.id,
          isExpanded: true, decoration: const InputDecoration(labelText: 'Student request'),
          items: requests.map((r) => DropdownMenuItem(value: r.id,
            child: Text('#${r.id} • ${r.city} • ${r.roomType}', overflow: TextOverflow.ellipsis))).toList(),
          validator: (v) => v == null ? 'Choose a request.' : null,
          onChanged: (v) => setState(() { requirementId = v; roomId = null; price.clear(); })),
        if (request != null) Padding(padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('Budget: ${money(request.budget)} / month\nAmenities: ${request.amenities.join(', ')}')),
        const SizedBox(height: 16),
        if (rooms.isEmpty) const Text('No available rooms match this request. Add inventory or choose another request.')
        else DropdownButtonFormField<int>(
          key: ValueKey('rooms-$requirementId-$roomId'), initialValue: rooms.any((r) => r.id == roomId) ? roomId : null,
          isExpanded: true, decoration: const InputDecoration(labelText: 'Available room'),
          items: rooms.map((r) => DropdownMenuItem(value: r.id,
            child: Text('${r.type} • ${money(r.pricePerBed)}'))).toList(),
          validator: (v) => v == null ? 'Choose a room.' : null,
          onChanged: (v) => setState(() {
            roomId = v;
            price.text = rooms.firstWhere((r) => r.id == v).pricePerBed.toString();
          })),
        const SizedBox(height: 16),
        TextFormField(controller: price, keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: priceValidator, decoration: const InputDecoration(labelText: 'Monthly offer (PKR)')),
        const SizedBox(height: 16),
        TextFormField(controller: note, minLines: 2, maxLines: 4, maxLength: 500,
          decoration: const InputDecoration(labelText: 'Message (optional)')),
        const SizedBox(height: 20),
        FilledButton(onPressed: requests.isEmpty || rooms.isEmpty ? null : submit,
          child: const Text('Post demo offer')),
      ])));
  });
}
