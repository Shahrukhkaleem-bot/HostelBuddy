class BidData {
  final int id;
  final String name;
  final double rating;
  final int price;
  final String thumbnail;
  final String roomType;
  final List<String> amenities;
  final String note;
  final String distance;
  final String status; // 'new' or 'pending'
  final String? manager;
  final String? phone;
  final String? email;
  final String? address;

  BidData({
    required this.id,
    required this.name,
    required this.rating,
    required this.price,
    required this.thumbnail,
    required this.roomType,
    required this.amenities,
    required this.note,
    required this.distance,
    required this.status,
    this.manager,
    this.phone,
    this.email,
    this.address,
  });
}

class MatchData {
  final String studentId;
  final String gender;
  final String city;
  final int budget;
  final String roomType;
  final List<String> amenities;
  final int matchScore;

  MatchData({
    required this.studentId,
    required this.gender,
    required this.city,
    required this.budget,
    required this.roomType,
    required this.amenities,
    required this.matchScore,
  });
}

class LeadData {
  final int id;
  final String name;
  final String phone;
  final String avatar;
  final String hostel;
  final String acceptedAt;

  LeadData({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatar,
    required this.hostel,
    required this.acceptedAt,
  });
}

class DummyData {
  static final List<BidData> bids = [
    BidData(
      id: 1,
      name: 'Al-Haram Hostel',
      rating: 4.8,
      price: 34000,
      thumbnail: '🏨',
      roomType: '2-Seater',
      amenities: ['UPS', 'Wi-Fi', 'Laundry'],
      note:
          'We have a newly renovated 2-seater room with backup power. 3x halal mess included. Special discount for students!',
      distance: '1.2 km',
      status: 'new',
      manager: 'Hassan Khan',
      phone: '0312-3456789',
      email: 'manager@alharam.pk',
      address: 'G-11, Islamabad',
    ),
    BidData(
      id: 2,
      name: 'Green Valley Hostel',
      rating: 4.6,
      price: 36000,
      thumbnail: '🌿',
      roomType: '1-Seater',
      amenities: ['UPS', 'Wi-Fi'],
      note:
          'Single room with attached bath. Quiet environment, perfect for studying. Near main market.',
      distance: '0.8 km',
      status: 'new',
      manager: 'Ayesha Malik',
      phone: '0321-8765432',
      email: 'info@greenvalley.pk',
      address: 'F-10, Islamabad',
    ),
    BidData(
      id: 3,
      name: 'City Tower Hostel',
      rating: 4.4,
      price: 32000,
      thumbnail: '🏢',
      roomType: '3-Seater',
      amenities: ['UPS', 'Wi-Fi', 'Mess', 'Laundry'],
      note:
          'Spacious 3-seater with all amenities. Mess serves delicious halal food. 24/7 security.',
      distance: '2.0 km',
      status: 'pending',
      manager: 'Muhammad Farooq',
      phone: '0333-1234567',
      email: 'contact@citytower.pk',
      address: 'Gulberg, Lahore',
    ),
    BidData(
      id: 4,
      name: 'Comfort Inn Hostel',
      rating: 4.9,
      price: 38000,
      thumbnail: '🏬',
      roomType: '2-Seater',
      amenities: ['UPS', 'Wi-Fi', 'Laundry'],
      note:
          'Premium 2-seater with AC, study desks, and high-speed internet. Laundry service included.',
      distance: '0.5 km',
      status: 'new',
      manager: 'Zara Ahmed',
      phone: '0345-9876543',
      email: 'reservations@comfortinn.pk',
      address: 'G-10, Islamabad',
    ),
  ];

  static final List<MatchData> matches = [
    MatchData(
      studentId: 'HB-2049',
      gender: 'Male',
      city: 'G-11, Islamabad',
      budget: 40000,
      roomType: '2-Seater',
      amenities: ['ups', 'wifi'],
      matchScore: 92,
    ),
    MatchData(
      studentId: 'HB-2051',
      gender: 'Female',
      city: 'G-10, Islamabad',
      budget: 28000,
      roomType: '3-Seater',
      amenities: ['ups', 'wifi', 'mess'],
      matchScore: 85,
    ),
    MatchData(
      studentId: 'HB-2053',
      gender: 'Male',
      city: 'F-10, Islamabad',
      budget: 45000,
      roomType: '1-Seater',
      amenities: ['ups', 'wifi', 'laundry'],
      matchScore: 78,
    ),
    MatchData(
      studentId: 'HB-2056',
      gender: 'Male',
      city: 'G-11, Islamabad',
      budget: 35000,
      roomType: '2-Seater',
      amenities: ['ups', 'wifi', 'mess', 'laundry'],
      matchScore: 95,
    ),
  ];

  static final List<LeadData> leads = [
    LeadData(
      id: 1,
      name: 'Ahmed Raza',
      phone: '0312-3456789',
      avatar: 'AR',
      hostel: 'Al-Haram Hostel',
      acceptedAt: '2 days ago',
    ),
    LeadData(
      id: 2,
      name: 'Sana Khan',
      phone: '0345-9876543',
      avatar: 'SK',
      hostel: 'Green Valley Hostel',
      acceptedAt: '5 days ago',
    ),
    LeadData(
      id: 3,
      name: 'Usman Ali',
      phone: '0333-4567890',
      avatar: 'UA',
      hostel: 'City Tower Hostel',
      acceptedAt: '1 week ago',
    ),
    LeadData(
      id: 4,
      name: 'Fatima Noor',
      phone: '0300-1122334',
      avatar: 'FN',
      hostel: 'Comfort Inn Hostel',
      acceptedAt: '2 weeks ago',
    ),
  ];

  static final List<String> cities = [
    'G-11, Islamabad',
    'G-10, Islamabad',
    'F-10, Islamabad',
    'Gulberg, Lahore',
    'Johar Town, Lahore',
    'Clifton, Karachi',
    'Gulshan, Karachi',
    'University Town, Peshawar',
  ];

  static String formatPrice(int price) {
    return 'PKR ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  static String getRoomLabel(int seats) {
    return '$seats-Seater';
  }

  static String getAmenityLabel(String key) {
    const map = {
      'ups': 'UPS/Generator',
      'wifi': 'Wi-Fi',
      'mess': '3x Mess (Halal)',
      'laundry': 'Laundry',
    };
    return map[key] ?? key;
  }

  static String getAmenityIcon(String key) {
    const map = {
      'ups': '⚡',
      'wifi': '📶',
      'mess': '🍴',
      'laundry': '👕',
    };
    return map[key] ?? '✓';
  }
}
