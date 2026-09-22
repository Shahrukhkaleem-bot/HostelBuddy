import 'package:flutter/material.dart';
import '../core/app_store.dart';
import '../models/complete_models.dart';
import '../widgets/marketplace_widgets.dart';

class HostelFormScreen extends StatefulWidget {
  final HostelData? hostel;
  const HostelFormScreen({super.key, this.hostel});
  @override
  State<HostelFormScreen> createState() => _HostelFormScreenState();
}
class _HostelFormScreenState extends State<HostelFormScreen> {
  final form = GlobalKey<FormState>();
  late final TextEditingController name, address, description, manager, phone;
  late String city;
  late Set<String> amenities;
  bool saving = false;
  @override
  void initState() {
    super.initState();
    final h = widget.hostel;
    name = TextEditingController(text: h?.name ?? '');
    address = TextEditingController(text: h?.address ?? '');
    description = TextEditingController(text: h?.description ?? '');
    manager = TextEditingController(text: h?.managerName ?? '');
    phone = TextEditingController(text: h?.managerPhone ?? '');
    city = h?.city ?? cities.first; amenities = {...?h?.amenities};
  }
  @override
  void dispose() {
    for (final c in [name, address, description, manager, phone]) { c.dispose(); }
    super.dispose();
  }
  void save() {
    if (saving || !form.currentState!.validate()) return;
    saving = true;
    final store = AppStore.instance;
    final old = widget.hostel == null ? null : store.hostel(widget.hostel!.id);
    if (widget.hostel != null && old == null) {
      saving = false; showMessage(context, 'This hostel is no longer available.'); return;
    }
    final value = old?.copyWith(name: name.text.trim(), address: address.text.trim(),
      description: description.text.trim(), managerName: manager.text.trim(),
      managerPhone: phone.text.trim(), city: city, amenities: amenities.toList()) ??
      HostelData(id: store.newId(), name: name.text.trim(), address: address.text.trim(), city: city,
        latitude: 0, longitude: 0, description: description.text.trim(),
        managerName: manager.text.trim(), managerPhone: phone.text.trim(),
        overallRating: 0, totalReviews: 0, amenities: amenities.toList(), rooms: [],
        totalCapacity: 0, imageUrl: '', galleryImages: [],
        ratingBreakdown: RatingBreakdown(cleanliness: 0, staff: 0, value: 0, location: 0, amenities: 0),
        reviews: [], registeredDate: DateTime.now());
    store.saveHostel(value);
    store.selectHostel(value.id);
    showMessage(context, 'Hostel saved to this demo workspace.');
    if (old == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/warden-home', (_) => false);
    } else { Navigator.pop(context, true); }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.hostel == null ? 'Register a hostel' : 'Edit hostel')),
    body: Form(key: form, child: PageBody(children: [
      const DemoNotice(),
      TextFormField(controller: name, textCapitalization: TextCapitalization.words,
        validator: (v) => requiredText(v, min: 3), maxLength: 100,
        decoration: const InputDecoration(labelText: 'Hostel name')),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(initialValue: city, isExpanded: true,
        decoration: const InputDecoration(labelText: 'City'),
        items: {city, ...cities}.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        onChanged: (v) { if (v != null) setState(() => city = v); }),
      const SizedBox(height: 16),
      TextFormField(controller: address, maxLength: 200, maxLines: 2,
        validator: (v) => requiredText(v, min: 5, max: 200),
        decoration: const InputDecoration(labelText: 'Street address')),
      const SizedBox(height: 12),
      TextFormField(controller: description, maxLength: 500, minLines: 3, maxLines: 5,
        validator: (v) => requiredText(v, min: 20, max: 500),
        decoration: const InputDecoration(labelText: 'Description')),
      const SizedBox(height: 12),
      TextFormField(controller: manager, maxLength: 100,
        validator: (v) => requiredText(v, min: 3),
        decoration: const InputDecoration(labelText: 'Manager name')),
      const SizedBox(height: 12),
      TextFormField(controller: phone, keyboardType: TextInputType.phone,
        maxLength: 20, validator: phoneValidator,
        decoration: const InputDecoration(labelText: 'Manager phone')),
      const SizedBox(height: 12),
      const Text('Amenities'),
      Wrap(spacing: 8, children: amenityOptions.map((a) => FilterChip(label: Text(a),
        selected: amenities.contains(a), onSelected: (v) => setState(() {
          if (v) { amenities.add(a); } else { amenities.remove(a); }
        }))).toList()),
      const SizedBox(height: 16),
      const Text('Room prices, capacity and availability are managed under Manage rooms after saving.'),
      const SizedBox(height: 16),
      FilledButton(onPressed: save, child: const Text('Save hostel')),
    ])),
  );
}

