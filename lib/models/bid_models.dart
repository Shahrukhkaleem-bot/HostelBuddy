enum BidStatus { received, pending, accepted, rejected, withdrawn }

class HostelRequirement {
  final int id;
  final String studentId;
  final String studentName;
  final String city;
  final int budget;
  final int seats;
  final List<String> amenities;
  final DateTime createdAt;

  HostelRequirement({
    required this.id, required this.studentId, required this.studentName,
    required this.city, required this.budget, required this.seats,
    required List<String> amenities, DateTime? createdAt,
  }) : amenities = List.unmodifiable(amenities), createdAt = createdAt ?? DateTime.now();

  String get roomType => '$seats-Seater';
}

class QuoteBid {
  final int id;
  final int requirementId;
  final int hostelId;
  final int roomId;
  final String roomType;
  final int price;
  final String note;
  final BidStatus status;
  final DateTime date;
  final bool chargedForPosting;

  QuoteBid({
    required this.id, required this.requirementId, required this.hostelId,
    required this.roomId, required this.roomType, required this.price,
    this.note = '', this.status = BidStatus.received,
    DateTime? date, this.chargedForPosting = false,
  }) : date = date ?? DateTime.now();

  bool get contactUnlocked => status == BidStatus.pending || status == BidStatus.accepted;
  QuoteBid withStatus(BidStatus value) => QuoteBid(
    id: id, requirementId: requirementId, hostelId: hostelId, roomId: roomId,
    roomType: roomType, price: price, note: note, status: value, date: date,
    chargedForPosting: chargedForPosting,
  );
}
