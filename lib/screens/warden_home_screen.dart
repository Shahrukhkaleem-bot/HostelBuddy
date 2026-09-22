import 'package:flutter/material.dart';
import '../core/app_store.dart';
import '../core/auth_service.dart';
import '../models/bid_models.dart';
import '../widgets/marketplace_widgets.dart';

class WardenHomeScreen extends StatelessWidget {
  const WardenHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => StoreBuilder(builder: (context, store) {
    final hostel = store.selectedHostel;
    return Scaffold(appBar: AppBar(title: const Text('Manager workspace'), automaticallyImplyLeading: false,
      actions: [IconButton(tooltip: 'Switch demo role', onPressed: () =>
        Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (_) => false), icon: const Icon(Icons.switch_account))]),
      body: PageBody(children: [
        const DemoNotice(),
        if (store.hostels.isNotEmpty) DropdownButtonFormField<int>(
          key: ValueKey(store.selectedHostelId), initialValue: hostel?.id, isExpanded: true,
          decoration: const InputDecoration(labelText: 'Selected demo hostel'),
          items: store.hostels.map((h) => DropdownMenuItem(value: h.id, child: Text(h.name))).toList(),
          onChanged: (id) { if (id != null) store.selectHostel(id); }),
        const SizedBox(height: 16),
        if (hostel != null) ...[
          Text(hostel.city, style: Theme.of(context).textTheme.titleMedium),
          Text('${hostel.rooms.fold<int>(0, (n, r) => n + r.availableBeds)} available beds • ${hostel.rooms.length} rooms'),
          Text('${store.bids.where((b) => b.hostelId == hostel.id && b.status == BidStatus.accepted).length} accepted demo offers'),
          const SizedBox(height: 20),
          _action(context, 'Student requests', Icons.search, '/warden-dashboard'),
          _action(context, 'My bids', Icons.inbox_outlined, '/manager-bids'),
          _action(context, 'Connected leads', Icons.contacts_outlined, '/connected-leads'),
          _action(context, 'Edit hostel details', Icons.edit_outlined, '/edit-hostel', hostel.id),
          _action(context, 'Manage rooms', Icons.bed_outlined, '/manage-rooms', hostel.id),
          _action(context, 'Analytics', Icons.insights, '/analytics-dashboard', hostel.id),
        ],
        _action(context, 'Register another hostel', Icons.add_business, '/hostel-registration'),
        TextButton(onPressed: () async {
          final navigator = Navigator.of(context);
          await AuthService.instance.signOut();
          store.signOut();
          navigator.pushNamedAndRemoveUntil('/google-auth', (_) => false);
        }, child: const Text('Sign out')),
      ]));
  });
  Widget _action(BuildContext context, String title, IconData icon, String route, [Object? args]) =>
    Padding(padding: const EdgeInsets.only(bottom: 10), child: OutlinedButton.icon(
      onPressed: () => Navigator.pushNamed(context, route, arguments: args),
      icon: Icon(icon), label: Text(title)));
}
