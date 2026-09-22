import 'package:flutter/material.dart';
import '../core/app_store.dart';
import '../core/hostel_search.dart';
import '../widgets/marketplace_widgets.dart';

class WardenDashboardScreen extends StatelessWidget {
  const WardenDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => StoreBuilder(builder: (context, store) => Scaffold(
    appBar: AppBar(title: const Text('Student requests')),
    body: PageBody(children: [
      const DemoNotice(),
      if (store.requirements.isEmpty) const Text('No requests yet. Create one in the student demo.'),
      ...store.requirements.map((r) => SectionCard(child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Request #${r.id}', style: Theme.of(context).textTheme.titleMedium),
          Text(r.city), Text('${r.roomType} • ${money(r.budget)} / month'),
          Text(r.amenities.isEmpty ? 'No required amenities' : r.amenities.join(' • ')),
          const SizedBox(height: 12),
          FilledButton(onPressed: () => Navigator.pushNamed(context, '/submit-bid', arguments: r.id),
            child: const Text('Make an offer')),
        ]))),
    ]),
  ));
}
