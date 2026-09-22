import '../models/complete_models.dart';
import '../models/bid_models.dart';

typedef Json = Map<String, dynamic>;
Json ratingJson(RatingBreakdown r) => {'cleanliness': r.cleanliness, 'staff': r.staff,
  'value': r.value, 'location': r.location, 'amenities': r.amenities};
RatingBreakdown ratingFrom(Json j) => RatingBreakdown(cleanliness: (j['cleanliness'] as num).toDouble(),
  staff: (j['staff'] as num).toDouble(), value: (j['value'] as num).toDouble(),
  location: (j['location'] as num).toDouble(), amenities: (j['amenities'] as num).toDouble());
Json roomJson(RoomData r) => {'id': r.id, 'type': r.type, 'capacity': r.capacity,
  'price': r.pricePerBed, 'available': r.availableBeds, 'amenities': r.amenities, 'image': r.imageUrl};
RoomData roomFrom(Json j) => RoomData(id: j['id'], type: j['type'], capacity: j['capacity'],
  pricePerBed: j['price'], availableBeds: (j['available'] as int).clamp(0, j['capacity'] as int),
  amenities: List<String>.from(j['amenities']), imageUrl: j['image']);
Json reviewJson(HostelReviewData r) => {'id': r.id, 'hostelId': r.hostelId, 'studentName': r.studentName,
  'studentId': r.studentId, 'rating': r.rating, 'title': r.title, 'description': r.description,
  'breakdown': ratingJson(r.breakdown), 'images': r.images, 'date': r.date.toIso8601String(), 'helpful': r.helpful};
HostelReviewData reviewFrom(Json j) => HostelReviewData(id: j['id'], hostelId: j['hostelId'],
  studentName: j['studentName'], studentId: j['studentId'], rating: (j['rating'] as num).toDouble(),
  title: j['title'], description: j['description'], breakdown: ratingFrom(j['breakdown']),
  images: List<String>.from(j['images']), date: DateTime.parse(j['date']), helpful: j['helpful']);
Json hostelJson(HostelData h) => {'id': h.id, 'name': h.name, 'address': h.address, 'city': h.city,
  'latitude': h.latitude, 'longitude': h.longitude, 'description': h.description,
  'managerName': h.managerName, 'managerPhone': h.managerPhone, 'rating': h.overallRating,
  'totalReviews': h.totalReviews, 'amenities': h.amenities, 'rooms': h.rooms.map(roomJson).toList(),
  'capacity': h.totalCapacity, 'image': h.imageUrl, 'gallery': h.galleryImages,
  'breakdown': ratingJson(h.ratingBreakdown), 'reviews': h.reviews.map(reviewJson).toList(),
  'registered': h.registeredDate.toIso8601String()};
HostelData hostelFrom(Json j) => HostelData(id: j['id'], name: j['name'], address: j['address'],
  city: j['city'], latitude: (j['latitude'] as num).toDouble(), longitude: (j['longitude'] as num).toDouble(),
  description: j['description'], managerName: j['managerName'], managerPhone: j['managerPhone'],
  overallRating: (j['rating'] as num).toDouble(), totalReviews: j['totalReviews'],
  amenities: List<String>.from(j['amenities']),
  rooms: (j['rooms'] as List).map((r) => roomFrom(r)).toList(),
  totalCapacity: j['capacity'], imageUrl: j['image'], galleryImages: List<String>.from(j['gallery']),
  ratingBreakdown: ratingFrom(j['breakdown']),
  reviews: (j['reviews'] as List).map((r) => reviewFrom(r)).toList(),
  registeredDate: DateTime.parse(j['registered']));
Json profileJson(StudentProfileData p) => {'id': p.id, 'name': p.name, 'email': p.email, 'phone': p.phone,
  'city': p.city, 'gender': p.gender, 'university': p.university, 'major': p.major,
  'image': p.profileImage, 'bio': p.bio, 'documents': p.documents, 'rating': p.rating,
  'reviews': p.totalReviews, 'registered': p.registeredDate.toIso8601String()};
StudentProfileData profileFrom(Json j) => StudentProfileData(id: j['id'], name: j['name'],
  email: j['email'], phone: j['phone'], city: j['city'], gender: j['gender'],
  university: j['university'], major: j['major'], profileImage: j['image'], bio: j['bio'],
  documents: List<String>.from(j['documents']), isVerified: false,
  rating: (j['rating'] as num).toDouble(), totalReviews: j['reviews'],
  registeredDate: DateTime.parse(j['registered']));
Json requirementJson(HostelRequirement r) => {'id': r.id, 'studentId': r.studentId,
  'studentName': r.studentName, 'city': r.city, 'budget': r.budget, 'seats': r.seats,
  'amenities': r.amenities, 'created': r.createdAt.toIso8601String()};
HostelRequirement requirementFrom(Json j) => HostelRequirement(id: j['id'], studentId: j['studentId'],
  studentName: j['studentName'], city: j['city'], budget: j['budget'], seats: j['seats'],
  amenities: List<String>.from(j['amenities']), createdAt: DateTime.parse(j['created']));
Json bidJson(QuoteBid b) => {'id': b.id, 'requirementId': b.requirementId,
  'hostelId': b.hostelId, 'roomId': b.roomId, 'roomType': b.roomType, 'price': b.price,
  'note': b.note, 'status': b.status.name, 'date': b.date.toIso8601String(), 'charged': b.chargedForPosting};
QuoteBid bidFrom(Json j) => QuoteBid(id: j['id'], requirementId: j['requirementId'],
  hostelId: j['hostelId'], roomId: j['roomId'], roomType: j['roomType'], price: j['price'],
  note: j['note'], status: BidStatus.values.byName(j['status']),
  date: DateTime.parse(j['date']), chargedForPosting: j['charged']);
Json studentReviewJson(StudentReviewData r) => {'id': r.id, 'studentId': r.studentId,
  'studentName': r.studentName, 'rating': r.rating, 'title': r.title, 'description': r.description,
  'date': r.date.toIso8601String(), 'hostelName': r.hostelName};
StudentReviewData studentReviewFrom(Json j) => StudentReviewData(id: j['id'], studentId: j['studentId'],
  studentName: j['studentName'], rating: (j['rating'] as num).toDouble(), title: j['title'],
  description: j['description'], date: DateTime.parse(j['date']), hostelName: j['hostelName']);

