import 'package:flutter/material.dart';
import '../core/app_store.dart';
import '../models/complete_models.dart';
import '../widgets/marketplace_widgets.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}
class _FavoritesScreenState extends State<FavoritesScreen> {
  String sort = 'recent';
  @override
  Widget build(BuildContext context) => StoreBuilder(builder: (context, store) {
    final favorites = store.favoriteIds.toList().reversed
      .map(store.hostel).whereType<HostelData>().toList();
    if (sort == 'rating') favorites.sort((a, b) => b.overallRating.compareTo(a.overallRating));
    if (sort == 'price') favorites.sort((a, b) => a.minPricePerBed.compareTo(b.minPricePerBed));
    return Scaffold(appBar: AppBar(title: const Text('My favorites')),
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
          Expanded(child: Text('${favorites.length} saved hostels')),
          DropdownButton<String>(value: sort, items: const [
            DropdownMenuItem(value: 'recent', child: Text('Recently saved')),
            DropdownMenuItem(value: 'rating', child: Text('Top rated')),
            DropdownMenuItem(value: 'price', child: Text('Lowest price')),
          ], onChanged: (v) { if (v != null) setState(() => sort = v); }),
        ])),
        Expanded(child: favorites.isEmpty ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.favorite_border, size: 48), const Text('No saved hostels yet'),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/hostel-listings'),
            child: const Text('Browse hostels')),
        ])) : ListView.builder(padding: const EdgeInsets.all(16), itemCount: favorites.length,
          itemBuilder: (context, index) => HostelTile(hostel: favorites[index]))),
      ])));
  });
}
