import 'package:flutter/material.dart';
import '../core/app_store.dart';
import '../core/hostel_search.dart';
import '../widgets/marketplace_widgets.dart';

class AdvancedSearchScreen extends StatefulWidget {
  final String title;
  const AdvancedSearchScreen({super.key, this.title = 'Find your hostel'});
  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final searchController = TextEditingController();
  String selectedCity = 'All';
  RangeValues priceRange = const RangeValues(5000, 100000);
  double minRating = 0;
  final Set<String> selectedAmenities = {};
  String selectedRoomType = 'All';
  int minCapacity = 1;
  String sortBy = 'rating';
  bool showFilters = false;
  String query = '';

  @override
  void dispose() { searchController.dispose(); super.dispose(); }
  void performSearch() {
    FocusScope.of(context).unfocus();
    setState(() => query = searchController.text);
  }
  void resetFilters() {
    setState(() {
      searchController.clear(); query = ''; selectedCity = 'All';
      priceRange = const RangeValues(5000, 100000); minRating = 0;
      selectedAmenities.clear(); selectedRoomType = 'All'; minCapacity = 1; sortBy = 'rating';
    });
  }

  @override
  Widget build(BuildContext context) => StoreBuilder(builder: (context, store) {
    final search = HostelSearch(query: query, city: selectedCity,
      minPrice: priceRange.start.round(), maxPrice: priceRange.end.round(),
      minRating: minRating, roomType: selectedRoomType, minBeds: minCapacity,
      amenities: selectedAmenities.toList(), sort: sortBy);
    final results = search.apply(store.hostels);
    final cityOptions = {'All', ...store.hostels.map((h) => h.city), ...cities}.toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                TextField(controller: searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => performSearch(),
                  onChanged: (value) => setState(() => query = value),
                  decoration: InputDecoration(labelText: 'Search name or location',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(tooltip: 'Clear search', icon: const Icon(Icons.clear),
                      onPressed: () => setState(() { searchController.clear(); query = ''; })))),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  FilledButton.icon(onPressed: performSearch, icon: const Icon(Icons.search), label: const Text('Search')),
                  OutlinedButton.icon(onPressed: () => setState(() => showFilters = !showFilters),
                    icon: const Icon(Icons.tune), label: Text(showFilters ? 'Hide filters' : 'Filters')),
                  TextButton(onPressed: resetFilters, child: const Text('Reset')),
                  DropdownButton<String>(value: sortBy, underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'rating', child: Text('Top rated')),
                      DropdownMenuItem(value: 'price', child: Text('Lowest price')),
                      DropdownMenuItem(value: 'newest', child: Text('Newest')),
                    ], onChanged: (value) { if (value != null) setState(() => sortBy = value); }),
                ]),
                if (showFilters) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(initialValue: selectedCity,
                    key: ValueKey('city-$selectedCity'), isExpanded: true,
                    decoration: const InputDecoration(labelText: 'City'),
                    items: cityOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (value) => setState(() => selectedCity = value ?? 'All')),
                  const SizedBox(height: 12),
                  Text('Monthly price: ${money(priceRange.start)} – ${money(priceRange.end)}'),
                  RangeSlider(values: priceRange, min: 5000, max: 100000, divisions: 95,
                    labels: RangeLabels(money(priceRange.start), money(priceRange.end)),
                    onChanged: (value) => setState(() => priceRange = value)),
                  DropdownButtonFormField<String>(initialValue: selectedRoomType,
                    key: ValueKey('room-$selectedRoomType'), isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Room type'),
                    items: ['All', ...roomTypes].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (value) => setState(() => selectedRoomType = value ?? 'All')),
                  const SizedBox(height: 12),
                  Text('Minimum rating: ${minRating.toStringAsFixed(1)}'),
                  Slider(value: minRating, min: 0, max: 5, divisions: 10,
                    label: minRating.toStringAsFixed(1), onChanged: (v) => setState(() => minRating = v)),
                  Wrap(spacing: 8, runSpacing: 4, children: amenityOptions.map((a) => FilterChip(
                    label: Text(a), selected: selectedAmenities.contains(a),
                    onSelected: (value) => setState(() {
                      if (value) { selectedAmenities.add(a); } else { selectedAmenities.remove(a); }
                    }))).toList()),
                  Row(children: [
                    const Expanded(child: Text('Available beds in one room')),
                    IconButton(tooltip: 'Fewer beds', onPressed: minCapacity <= 1 ? null :
                      () => setState(() => minCapacity--), icon: const Icon(Icons.remove)),
                    Text('$minCapacity'),
                    IconButton(tooltip: 'More beds', onPressed: minCapacity >= 4 ? null :
                      () => setState(() => minCapacity++), icon: const Icon(Icons.add)),
                  ]),
                ],
                const SizedBox(height: 12),
                Text('${results.length} matching hostels', style: Theme.of(context).textTheme.titleMedium),
                if (results.isEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(children: [
                    const Icon(Icons.search_off, size: 48),
                    const Text('No available rooms match all your filters.'),
                    TextButton(onPressed: resetFilters, child: const Text('Clear filters')),
                  ])),
              ]))),
          SliverPadding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList.builder(itemCount: results.length,
              itemBuilder: (context, index) => HostelTile(hostel: results[index],
                matchingPrice: search.price(results[index])))),
        ],
      )),
    );
  });
}
