import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'demo_codec.dart';
import '../models/complete_models.dart';
import '../models/bid_models.dart';

/// Frontend demo state. No authentication, payment or server persistence is implied.
class AppStore extends ChangeNotifier {
  static final AppStore instance = AppStore();
  AppStore() { _seed(); }

  SharedPreferences? _preferences;
  Future<void> _pendingSave = Future.value();
  String? storageError;

  Future<void> initialize() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      final data = _preferences!.getString('hostel_buddy_demo_v1');
      if (data != null) restore(jsonDecode(data) as Json);
    } catch (_) {
      storageError = 'Local data could not be loaded. This session is using sample data.';
    }
    super.notifyListeners();
  }

  Json snapshot() => {'version': 1, 'role': role,
    'profile': profileJson(profile), 'hostels': _hostels.map(hostelJson).toList(),
    'favorites': _favorites.toList(), 'requirements': _requirements.map(requirementJson).toList(),
    'bids': _bids.map(bidJson).toList(), 'studentReviews': _studentReviews.map(studentReviewJson).toList(),
    'selectedHostelId': selectedHostelId, 'studentCoins': studentCoins, 'managerCoins': managerCoins,
    'nextId': _nextId, 'notificationsEnabled': notificationsEnabled};

  void restore(Json j) {
    if (j['version'] != 1) throw const FormatException('Unsupported demo data');
    // Decode completely before changing state, so damaged data cannot partially load.
    final restoredProfile = profileFrom(j['profile']);
    final restoredHostels = (j['hostels'] as List).map((h) => hostelFrom(h)).toList();
    final restoredRequirements = (j['requirements'] as List).map((r) => requirementFrom(r)).toList();
    final restoredBids = (j['bids'] as List).map((b) => bidFrom(b)).toList();
    final restoredReviews = (j['studentReviews'] as List).map((r) => studentReviewFrom(r)).toList();
    final restoredFavorites = List<int>.from(j['favorites']);
    final nextId = j['nextId'] as int;
    final studentBalance = j['studentCoins'] as int;
    final managerBalance = j['managerCoins'] as int;
    final selectedId = j['selectedHostelId'] as int?;
    final restoredRole = j['role'] as String?;
    final notifications = j['notificationsEnabled'] as bool;
    profile = restoredProfile; _hostels = restoredHostels;
    _requirements..clear()..addAll(restoredRequirements);
    _bids..clear()..addAll(restoredBids);
    _studentReviews..clear()..addAll(restoredReviews);
    _favorites..clear()..addAll(restoredFavorites.where((id) => hostel(id) != null));
    _nextId = nextId; studentCoins = studentBalance; managerCoins = managerBalance;
    selectedHostelId = hostel(selectedId) == null ? _hostels.firstOrNull?.id : selectedId;
    role = ['student', 'manager'].contains(restoredRole) ? restoredRole : null;
    notificationsEnabled = notifications;
  }

  Future<void> flush() => _pendingSave;
  @override
  void notifyListeners() {
    super.notifyListeners();
    if (_preferences == null) return;
    final value = jsonEncode(snapshot());
    _pendingSave = _pendingSave.then((_) async {
      try {
        final saved = await _preferences!.setString('hostel_buddy_demo_v1', value);
        if (!saved) throw StateError('Save failed');
        if (storageError != null) { storageError = null; super.notifyListeners(); }
      } catch (_) {
        storageError = 'Changes are available in this session but could not be saved on this device.';
        super.notifyListeners();
      }
    });
  }

  void signOut() { role = null; notifyListeners(); }
  String? role;
  late StudentProfileData profile;
  List<HostelData> _hostels = [];
  final Set<int> _favorites = {};
  final List<HostelRequirement> _requirements = [];
  final List<QuoteBid> _bids = [];
  final List<StudentReviewData> _studentReviews = [];
  int? selectedHostelId;
  int studentCoins = 5000;
  int managerCoins = 8000;
  bool notificationsEnabled = true;
  int _nextId = 100;

  List<HostelData> get hostels => List.unmodifiable(_hostels);
  Set<int> get favoriteIds => Set.unmodifiable(_favorites);
  List<HostelRequirement> get requirements => List.unmodifiable(_requirements);
  List<QuoteBid> get bids => List.unmodifiable(_bids);
  List<StudentReviewData> get studentReviews => List.unmodifiable(_studentReviews);
  HostelData? get selectedHostel => hostel(selectedHostelId);
  bool isFavorite(int id) => _favorites.contains(id);

  void _seed() {
    profile = profileFrom(profileJson(CompleteDummyData.studentProfiles.first));
    _hostels = CompleteDummyData.hostels.map((h) {
      final rooms = h.rooms.map((r) => RoomData(
        id: r.id, type: r.type, capacity: r.capacity, pricePerBed: r.pricePerBed,
        availableBeds: r.availableBeds.clamp(0, r.capacity),
        amenities: List.unmodifiable(r.amenities), imageUrl: r.imageUrl,
      )).toList();
      return h.copyWith(rooms: rooms,
        totalCapacity: rooms.fold<int>(0, (n, r) => n + r.capacity),
        totalReviews: h.reviews.length,
        overallRating: h.reviews.isEmpty ? 0 :
          h.reviews.fold<double>(0, (n, r) => n + r.rating) / h.reviews.length);
    }).toList();
    selectedHostelId = _hostels.length > 1 ? _hostels[1].id : _hostels.firstOrNull?.id;
    _requirements.add(HostelRequirement(id: 1, studentId: profile.id,
      studentName: profile.name, city: 'G-11, Islamabad', budget: 35000,
      seats: 2, amenities: ['Wi-Fi']));
    for (final h in _hostels.where((h) => h.city == _requirements.first.city)) {
      final room = h.rooms.where((r) => r.type == '2-Seater').firstOrNull;
      if (room != null) {
        _bids.add(QuoteBid(id: _nextId++, requirementId: 1, hostelId: h.id,
          roomId: room.id, roomType: room.type, price: room.pricePerBed,
          note: 'Sample offer for your requirement.'));
      }
    }
  }

  void reset() {
    role = null; _favorites.clear(); _requirements.clear(); _bids.clear();
    _studentReviews.clear(); studentCoins = 5000; managerCoins = 8000;
    _nextId = 100; notificationsEnabled = true; _seed(); notifyListeners();
  }

  HostelData? hostel(int? id) => _hostels.where((h) => h.id == id).firstOrNull;
  HostelRequirement? requirement(int? id) => _requirements.where((r) => r.id == id).firstOrNull;
  QuoteBid? bid(int? id) => _bids.where((b) => b.id == id).firstOrNull;
  void setRole(String value) { role = value; notifyListeners(); }
  void selectHostel(int id) {
    if (hostel(id) == null) return;
    selectedHostelId = id; notifyListeners();
  }
  void toggleFavorite(int id) {
    if (hostel(id) == null) return;
    if (!_favorites.add(id)) _favorites.remove(id);
    notifyListeners();
  }
  void saveHostel(HostelData value) {
    final index = _hostels.indexWhere((h) => h.id == value.id);
    if (index < 0) { _hostels.add(value); } else { _hostels[index] = value; }
    notifyListeners();
  }
  int newId() => _nextId++;
  void saveRooms(int hostelId, List<RoomData> rooms) {
    final current = hostel(hostelId);
    if (current == null) return;
    saveHostel(current.copyWith(rooms: rooms,
      totalCapacity: rooms.fold<int>(0, (sum, room) => sum + room.capacity)));
  }
  String? deleteRoom(int hostelId, int roomId) {
    if (_bids.any((b) => b.hostelId == hostelId && b.roomId == roomId &&
        (b.status == BidStatus.received || b.status == BidStatus.pending || b.status == BidStatus.accepted))) {
      return 'This room has an active offer. Close the offer before deleting it.';
    }
    final h = hostel(hostelId);
    if (h == null) return 'Hostel is unavailable.';
    saveRooms(hostelId, h.rooms.where((r) => r.id != roomId).toList());
    return null;
  }
  void saveProfile(StudentProfileData value) {
    profile = value;
    for (var i = 0; i < _requirements.length; i++) {
      final r = _requirements[i];
      if (r.studentId == value.id) {
        _requirements[i] = HostelRequirement(id: r.id, studentId: r.studentId,
          studentName: value.name, city: r.city, budget: r.budget, seats: r.seats,
          amenities: r.amenities, createdAt: r.createdAt);
      }
    }
    notifyListeners();
  }
  /// Replaces the demo identity with the signed-in user's details. Blank values
  /// are ignored so a missing field never wipes what the user already entered.
  void applyIdentity({String? name, String? email, String? avatarUrl,
      String? phone, String? city}) {
    String? keep(String? value) =>
      value == null || value.trim().isEmpty ? null : value.trim();
    saveProfile(profile.copyWith(
      name: keep(name), email: keep(email), profileImage: keep(avatarUrl),
      phone: keep(phone), city: keep(city),
    ));
  }

  HostelRequirement postRequirement({required String city, required int budget,
      required int seats, required List<String> amenities}) {
    final value = HostelRequirement(id: newId(), studentId: profile.id,
      studentName: profile.name, city: city, budget: budget, seats: seats, amenities: amenities);
    _requirements.insert(0, value); notifyListeners(); return value;
  }
  String? postBid({required int requirementId, required int hostelId,
      required int roomId, required int price, String note = ''}) {
    final r = requirement(requirementId);
    final h = hostel(hostelId);
    final room = h?.rooms.where((r) => r.id == roomId).firstOrNull;
    if (r == null || h == null || room == null) return 'Select an available request and room.';
    if (room.availableBeds < 1 || room.type != r.roomType) return 'Choose an available room matching the request.';
    if (price < 5000 || price > 1000000) return 'Price must be between PKR 5,000 and 1,000,000.';
    if (_bids.any((b) => b.requirementId == r.id && b.hostelId == h.id &&
        (b.status == BidStatus.received || b.status == BidStatus.pending || b.status == BidStatus.accepted))) {
      return 'You already have an active offer for this request.';
    }
    if (managerCoins < 50) return 'Not enough demo coins.';
    managerCoins -= 50;
    _bids.insert(0, QuoteBid(id: newId(), requirementId: r.id, hostelId: h.id,
      roomId: room.id, roomType: room.type, price: price, note: note.trim(), chargedForPosting: true));
    notifyListeners(); return null;
  }
  String? unlockBid(int id) {
    final b = bid(id);
    if (b == null) return 'Offer is unavailable.';
    if (b.contactUnlocked) return null;
    if (b.status != BidStatus.received) return 'This offer is closed.';
    if (studentCoins < 100) return 'Not enough demo coins.';
    studentCoins -= 100;
    _replaceBid(b.withStatus(BidStatus.pending)); return null;
  }
  String? closeBid(int id, bool accept) {
    final b = bid(id);
    if (b == null || (b.status != BidStatus.received && b.status != BidStatus.pending)) {
      return 'This offer is already closed.';
    }
    if (accept && b.status != BidStatus.pending) return 'Unlock the offer before accepting it.';
    if (accept) {
      final h = hostel(b.hostelId);
      final room = h?.rooms.where((r) => r.id == b.roomId).firstOrNull;
      if (room == null || room.availableBeds < 1) return 'This room is no longer available.';
      if (_bids.any((other) => other.requirementId == b.requirementId && other.status == BidStatus.accepted)) {
        return 'This request already has an accepted offer.';
      }
    }
    _replaceBid(b.withStatus(accept ? BidStatus.accepted : BidStatus.rejected));
    return null;
  }
  String? withdrawBid(int id) {
    final b = bid(id);
    if (b == null || b.status != BidStatus.received) return 'Only an unreviewed offer can be withdrawn.';
    if (b.chargedForPosting) managerCoins += 50;
    _replaceBid(b.withStatus(BidStatus.withdrawn)); return null;
  }
  void _replaceBid(QuoteBid value) {
    final index = _bids.indexWhere((b) => b.id == value.id);
    if (index < 0) return;
    _bids[index] = value; notifyListeners();
  }
  void reviewHostel(int id, String title, String description, RatingBreakdown breakdown) {
    final h = hostel(id);
    if (h == null) return;
    final reviews = h.reviews.where((r) => r.studentId != profile.id).toList()
      ..insert(0, HostelReviewData(id: newId(), hostelId: id, studentName: profile.name,
        studentId: profile.id, rating: breakdown.getAverage(), title: title,
        description: description, breakdown: breakdown, images: [],
        date: DateTime.now(), helpful: 0));
    double mean(double Function(RatingBreakdown) get) =>
      reviews.fold<double>(0, (n, r) => n + get(r.breakdown)) / reviews.length;
    saveHostel(h.copyWith(reviews: reviews, totalReviews: reviews.length,
      overallRating: reviews.fold<double>(0, (n, r) => n + r.rating) / reviews.length,
      ratingBreakdown: RatingBreakdown(cleanliness: mean((r) => r.cleanliness),
        staff: mean((r) => r.staff), value: mean((r) => r.value),
        location: mean((r) => r.location), amenities: mean((r) => r.amenities))));
  }
  void reviewStudent(StudentReviewData review) {
    _studentReviews.removeWhere((r) => r.studentId == review.studentId && r.hostelName == review.hostelName);
    _studentReviews.insert(0, review); notifyListeners();
  }
  void setNotifications(bool value) { notificationsEnabled = value; notifyListeners(); }
}

class StoreBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AppStore) builder;
  const StoreBuilder({super.key, required this.builder});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: AppStore.instance,
    builder: (context, _) => builder(context, AppStore.instance),
  );
}
