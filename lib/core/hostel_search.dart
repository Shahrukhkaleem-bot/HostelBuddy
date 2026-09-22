import '../models/complete_models.dart';

class HostelSearch {
  final String query;
  final String city;
  final int minPrice;
  final int maxPrice;
  final double minRating;
  final String roomType;
  final int minBeds;
  final List<String> amenities;
  final String sort;
  const HostelSearch({this.query = '', this.city = 'All', this.minPrice = 5000,
    this.maxPrice = 100000, this.minRating = 0, this.roomType = 'All',
    this.minBeds = 1, this.amenities = const [], this.sort = 'rating'});

  List<RoomData> matchingRooms(HostelData h) => h.rooms.where((r) =>
    r.pricePerBed >= minPrice && r.pricePerBed <= maxPrice &&
    (roomType == 'All' || r.type == roomType) && r.availableBeds >= minBeds &&
    amenities.every((a) => [...h.amenities, ...r.amenities]
      .any((value) => normalizeAmenity(value) == normalizeAmenity(a)))).toList();

  int? price(HostelData h) {
    final rooms = matchingRooms(h);
    return rooms.isEmpty ? null : rooms.map((r) => r.pricePerBed).reduce((a, b) => a < b ? a : b);
  }

  List<HostelData> apply(Iterable<HostelData> hostels) {
    final term = query.trim().toLowerCase();
    final result = hostels.where((h) =>
      (term.isEmpty || '${h.name} ${h.address} ${h.city}'.toLowerCase().contains(term)) &&
      (city == 'All' || city == h.city) && h.overallRating >= minRating &&
      matchingRooms(h).isNotEmpty).toList();
    switch (sort) {
      case 'price': result.sort((a, b) => price(a)!.compareTo(price(b)!)); break;
      case 'newest': result.sort((a, b) => b.registeredDate.compareTo(a.registeredDate)); break;
      default: result.sort((a, b) => b.overallRating.compareTo(a.overallRating));
    }
    return result;
  }
}

String normalizeAmenity(String value) => value.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
String money(num value) => 'PKR ${value.toStringAsFixed(0).replaceAllMapped(
  RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

