import 'package:flutter/material.dart';
import '../core/app_store.dart';
import '../core/hostel_search.dart';
import '../widgets/marketplace_widgets.dart';

class ResidentHomeScreen extends StatelessWidget {
  const ResidentHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => StoreBuilder(builder: (context, store) => Scaffold(
    appBar: AppBar(title: const Text('HostelBuddy'), automaticallyImplyLeading: false,
      actions: [IconButton(tooltip: 'My favorites', onPressed: () =>
        Navigator.pushNamed(context, '/favorites'), icon: const Icon(Icons.favorite_border))]),
    body: PageBody(children: [
      Text('Welcome, ${store.profile.name}', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 12), const DemoNotice(),
      FilledButton.icon(onPressed: () => Navigator.pushNamed(context, '/post-requirement'),
        icon: const Icon(Icons.add), label: const Text('Post a requirement')),
      const SizedBox(height: 20),
      Text('Your requests', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      if (store.requirements.isEmpty) const Text('No requests yet. Tell managers what you need.'),
      ...store.requirements.map((r) => Card(child: ListTile(
        title: Text('${r.city} • ${r.roomType}'),
        subtitle: Text('${money(r.budget)} / month\n${store.bids.where((b) => b.requirementId == r.id).length} offers'),
        isThreeLine: true, trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, '/bids-inbox', arguments: r.id)))),
      const SizedBox(height: 20),
      Text('Discover hostels', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      ...store.hostels.take(3).map((h) => HostelTile(hostel: h)),
    ]),
  ));
}
