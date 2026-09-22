// Hostel Model
class HostelData {
  final int id;
  final String name;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String description;
  final String managerName;
  final String managerPhone;
  final double overallRating;
  final int totalReviews;
  final List<String> amenities;
  final List<RoomData> rooms;
  final int totalCapacity;
  final String imageUrl;
  final List<String> galleryImages;
  final RatingBreakdown ratingBreakdown;
  final List<HostelReviewData> reviews;
  final DateTime registeredDate;

  HostelData({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.managerName,
    required this.managerPhone,
    required this.overallRating,
    required this.totalReviews,
    required this.amenities,
    required this.rooms,
    required this.totalCapacity,
    required this.imageUrl,
    required this.galleryImages,
    required this.ratingBreakdown,
    required this.reviews,
    required this.registeredDate,
  });

  HostelData copyWith({
    String? name, String? address, String? city, String? description,
    String? managerName, String? managerPhone, List<String>? amenities,
    List<RoomData>? rooms, int? totalCapacity, List<HostelReviewData>? reviews,
    double? overallRating, int? totalReviews, RatingBreakdown? ratingBreakdown,
  }) => HostelData(
    id: id, name: name ?? this.name, address: address ?? this.address,
    city: city ?? this.city, latitude: latitude, longitude: longitude,
    description: description ?? this.description,
    managerName: managerName ?? this.managerName,
    managerPhone: managerPhone ?? this.managerPhone,
    overallRating: overallRating ?? this.overallRating,
    totalReviews: totalReviews ?? this.totalReviews,
    amenities: List.unmodifiable(amenities ?? this.amenities),
    rooms: List.unmodifiable(rooms ?? this.rooms),
    totalCapacity: totalCapacity ?? this.totalCapacity, imageUrl: imageUrl,
    galleryImages: galleryImages, ratingBreakdown: ratingBreakdown ?? this.ratingBreakdown,
    reviews: List.unmodifiable(reviews ?? this.reviews), registeredDate: registeredDate,
  );

  /// Cheapest bed across all rooms, or 0 when the hostel has no rooms.
  int get minPricePerBed => rooms.isEmpty
      ? 0
      : rooms.map((room) => room.pricePerBed).reduce((a, b) => a < b ? a : b);
}

// Room Model
class RoomData {
  final int id;
  final String type; // 1-seater, 2-seater, 3-seater
  final int capacity;
  final int pricePerBed;
  final int availableBeds;
  final List<String> amenities;
  final String imageUrl;

  RoomData({
    required this.id,
    required this.type,
    required this.capacity,
    required this.pricePerBed,
    required this.availableBeds,
    required this.amenities,
    required this.imageUrl,
  });
}

// Rating Breakdown
class RatingBreakdown {
  final double cleanliness;
  final double staff;
  final double value;
  final double location;
  final double amenities;

  RatingBreakdown({
    required this.cleanliness,
    required this.staff,
    required this.value,
    required this.location,
    required this.amenities,
  });

  double getAverage() =>
      (cleanliness + staff + value + location + amenities) / 5;
}

// Review Model (for Hostels - Students reviewing hostels)
class HostelReviewData {
  final int id;
  final int hostelId;
  final String studentName;
  final String studentId;
  final double rating;
  final String title;
  final String description;
  final RatingBreakdown breakdown;
  final List<String> images;
  final DateTime date;
  final int helpful;

  HostelReviewData({
    required this.id,
    required this.hostelId,
    required this.studentName,
    required this.studentId,
    required this.rating,
    required this.title,
    required this.description,
    required this.breakdown,
    required this.images,
    required this.date,
    required this.helpful,
  });
}

// Student Review Model (for Students - Hostels reviewing students)
class StudentReviewData {
  final int id;
  final String studentId;
  final String studentName;
  final double rating;
  final String title;
  final String description;
  final DateTime date;
  final String hostelName;

  StudentReviewData({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rating,
    required this.title,
    required this.description,
    required this.date,
    required this.hostelName,
  });
}

// Booking Model
class BookingData {
  final int id;
  final int hostelId;
  final String studentId;
  final String roomType;
  final int pricePerBed;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String status; // pending, confirmed, checked-in, completed, cancelled
  final int numberOfBeds;
  final int totalPrice;
  final DateTime bookingDate;

  BookingData({
    required this.id,
    required this.hostelId,
    required this.studentId,
    required this.roomType,
    required this.pricePerBed,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.numberOfBeds,
    required this.totalPrice,
    required this.bookingDate,
  });
}

// Student Profile Model
class StudentProfileData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String gender;
  final String university;
  final String major;
  final String profileImage;
  final String bio;
  final List<String> documents;
  final bool isVerified;
  final double rating;
  final int totalReviews;
  final DateTime registeredDate;

  StudentProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.gender,
    required this.university,
    required this.major,
    required this.profileImage,
    required this.bio,
    required this.documents,
    required this.isVerified,
    required this.rating,
    required this.totalReviews,
    required this.registeredDate,
  });

  StudentProfileData copyWith({
    String? name, String? email, String? phone, String? city, String? gender,
    String? university, String? major, String? profileImage, String? bio,
    List<String>? documents, bool? isVerified,
  }) => StudentProfileData(
    id: id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    city: city ?? this.city,
    gender: gender ?? this.gender,
    university: university ?? this.university,
    major: major ?? this.major,
    profileImage: profileImage ?? this.profileImage,
    bio: bio ?? this.bio,
    documents: List.unmodifiable(documents ?? this.documents),
    isVerified: isVerified ?? this.isVerified,
    rating: rating,
    totalReviews: totalReviews,
    registeredDate: registeredDate,
  );
}

// Analytics Data
class AnalyticsData {
  final int totalBookings;
  final int completedBookings;
  final int pendingBookings;
  final double revenue;
  final double averageRating;
  final int totalReviews;
  final int occupancyRate;
  final List<BookingData> recentBookings;

  AnalyticsData({
    required this.totalBookings,
    required this.completedBookings,
    required this.pendingBookings,
    required this.revenue,
    required this.averageRating,
    required this.totalReviews,
    required this.occupancyRate,
    required this.recentBookings,
  });
}

// Dummy Data Provider
class CompleteDummyData {
  static final List<HostelData> hostels = [
    HostelData(
      id: 1,
      name: 'Al-Haram Hostel',
      address: 'G-11, Block A, Street 5',
      city: 'G-11, Islamabad',
      latitude: 33.7295,
      longitude: 73.1500,
      description:
          'Premium hostel with modern amenities, ideal for students. Located near universities and shopping areas.',
      managerName: 'Hassan Khan',
      managerPhone: '0312-3456789',
      overallRating: 4.8,
      totalReviews: 124,
      amenities: ['UPS', 'Wi-Fi', 'Laundry', 'Mess', 'Security'],
      rooms: [
        RoomData(
          id: 1,
          type: '1-Seater',
          capacity: 1,
          pricePerBed: 28000,
          availableBeds: 5,
          amenities: ['AC', 'WiFi', 'Attached Bath'],
          imageUrl: '🏠',
        ),
        RoomData(
          id: 2,
          type: '2-Seater',
          capacity: 2,
          pricePerBed: 18000,
          availableBeds: 3,
          amenities: ['AC', 'WiFi', 'Attached Bath'],
          imageUrl: '🏠',
        ),
        RoomData(
          id: 3,
          type: '3-Seater',
          capacity: 3,
          pricePerBed: 15000,
          availableBeds: 2,
          amenities: ['WiFi', 'Attached Bath'],
          imageUrl: '🏠',
        ),
      ],
      totalCapacity: 45,
      imageUrl: '🏨',
      galleryImages: ['🏨', '🛏️', '🍽️', '📶'],
      ratingBreakdown: RatingBreakdown(
        cleanliness: 4.9,
        staff: 4.7,
        value: 4.6,
        location: 5.0,
        amenities: 4.8,
      ),
      reviews: [
        HostelReviewData(
          id: 1,
          hostelId: 1,
          studentName: 'Ahmed Raza',
          studentId: 'S001',
          rating: 5.0,
          title: 'Excellent hostel, highly recommended',
          description:
              'Great location, clean rooms, friendly staff. Very satisfied with my stay.',
          breakdown: RatingBreakdown(
            cleanliness: 5.0,
            staff: 5.0,
            value: 4.5,
            location: 5.0,
            amenities: 5.0,
          ),
          images: [],
          date: DateTime.now().subtract(const Duration(days: 10)),
          helpful: 15,
        ),
      ],
      registeredDate: DateTime(2023, 1, 15),
    ),
    HostelData(
      id: 2,
      name: 'Green Valley Hostel',
      address: 'F-10, Sector 4, Avenue 3',
      city: 'F-10, Islamabad',
      latitude: 33.7234,
      longitude: 73.1456,
      description:
          'Quiet and peaceful hostel environment, perfect for focused students. Near parks and recreational areas.',
      managerName: 'Ayesha Malik',
      managerPhone: '0321-8765432',
      overallRating: 4.6,
      totalReviews: 98,
      amenities: ['UPS', 'Wi-Fi', 'Garden', 'Security'],
      rooms: [
        RoomData(
          id: 1,
          type: '1-Seater',
          capacity: 1,
          pricePerBed: 24000,
          availableBeds: 8,
          amenities: ['WiFi', 'Attached Bath'],
          imageUrl: '🏠',
        ),
        RoomData(
          id: 2,
          type: '2-Seater',
          capacity: 2,
          pricePerBed: 15000,
          availableBeds: 5,
          amenities: ['WiFi', 'Attached Bath'],
          imageUrl: '🏠',
        ),
      ],
      totalCapacity: 38,
      imageUrl: '🌿',
      galleryImages: ['🌿', '🏞️', '🌳', '☀️'],
      ratingBreakdown: RatingBreakdown(
        cleanliness: 4.8,
        staff: 4.5,
        value: 4.7,
        location: 4.4,
        amenities: 4.5,
      ),
      reviews: [
        HostelReviewData(
          id: 2,
          hostelId: 2,
          studentName: 'Sana Khan',
          studentId: 'S002',
          rating: 4.5,
          title: 'Good hostel with peaceful atmosphere',
          description:
              'Very quiet and calm place. Good for studying. Staff is cooperative.',
          breakdown: RatingBreakdown(
            cleanliness: 4.5,
            staff: 4.5,
            value: 4.5,
            location: 4.0,
            amenities: 4.5,
          ),
          images: [],
          date: DateTime.now().subtract(const Duration(days: 15)),
          helpful: 12,
        ),
      ],
      registeredDate: DateTime(2023, 2, 20),
    ),
    HostelData(
      id: 3,
      name: 'City Tower Hostel',
      address: 'Gulberg, Block E, Street 7',
      city: 'Gulberg, Lahore',
      latitude: 31.5497,
      longitude: 74.3436,
      description:
          'Modern hostel in the heart of the city. Close to commercial area and entertainment venues.',
      managerName: 'Muhammad Farooq',
      managerPhone: '0333-1234567',
      overallRating: 4.4,
      totalReviews: 76,
      amenities: ['UPS', 'Wi-Fi', 'Mess', 'Laundry', 'Security'],
      rooms: [
        RoomData(
          id: 1,
          type: '2-Seater',
          capacity: 2,
          pricePerBed: 20000,
          availableBeds: 4,
          amenities: ['AC', 'WiFi', 'Attached Bath'],
          imageUrl: '🏠',
        ),
        RoomData(
          id: 2,
          type: '3-Seater',
          capacity: 3,
          pricePerBed: 16000,
          availableBeds: 3,
          amenities: ['WiFi', 'Attached Bath'],
          imageUrl: '🏠',
        ),
      ],
      totalCapacity: 50,
      imageUrl: '🏢',
      galleryImages: ['🏢', '🌆', '🛏️', '🍴'],
      ratingBreakdown: RatingBreakdown(
        cleanliness: 4.5,
        staff: 4.3,
        value: 4.2,
        location: 4.6,
        amenities: 4.4,
      ),
      reviews: [
        HostelReviewData(
          id: 3,
          hostelId: 3,
          studentName: 'Usman Ali',
          studentId: 'S003',
          rating: 4.0,
          title: 'Good location, average facilities',
          description:
              'Location is great for city access. Facilities are average. Could be better.',
          breakdown: RatingBreakdown(
            cleanliness: 4.0,
            staff: 4.0,
            value: 4.0,
            location: 5.0,
            amenities: 4.0,
          ),
          images: [],
          date: DateTime.now().subtract(const Duration(days: 20)),
          helpful: 8,
        ),
      ],
      registeredDate: DateTime(2023, 3, 10),
    ),
  ];

  static final List<StudentProfileData> studentProfiles = [
    StudentProfileData(
      id: 'S001',
      name: 'Ahmed Raza',
      email: 'ahmed.raza@email.com',
      phone: '0345-9876543',
      city: 'G-11, Islamabad',
      gender: 'Male',
      university: 'FAST-NUCES',
      major: 'Computer Science',
      profileImage: '👨‍🎓',
      bio: 'Engineering student, focused on studies',
      documents: ['student_id.jpg', 'cnic.jpg'],
      isVerified: true,
      rating: 4.8,
      totalReviews: 12,
      registeredDate: DateTime(2024, 1, 15),
    ),
    StudentProfileData(
      id: 'S002',
      name: 'Sana Khan',
      email: 'sana.khan@email.com',
      phone: '0321-5432109',
      city: 'F-10, Islamabad',
      gender: 'Female',
      university: 'IIU',
      major: 'Business Administration',
      profileImage: '👩‍🎓',
      bio: 'Business student, looking for quiet hostel',
      documents: ['student_id.jpg'],
      isVerified: true,
      rating: 4.6,
      totalReviews: 8,
      registeredDate: DateTime(2024, 2, 20),
    ),
  ];

  static final List<BookingData> bookings = [
    BookingData(
      id: 1,
      hostelId: 1,
      studentId: 'S001',
      roomType: '2-Seater',
      pricePerBed: 18000,
      checkInDate: DateTime.now().add(const Duration(days: 5)),
      checkOutDate: DateTime.now().add(const Duration(days: 95)),
      status: 'confirmed',
      numberOfBeds: 1,
      totalPrice: 1620000,
      bookingDate: DateTime.now(),
    ),
  ];

  static final AnalyticsData analytics = AnalyticsData(
    totalBookings: 45,
    completedBookings: 38,
    pendingBookings: 7,
    revenue: 3600000,
    averageRating: 4.8,
    totalReviews: 124,
    occupancyRate: 85,
    recentBookings: [
      BookingData(
        id: 1,
        hostelId: 1,
        studentId: 'S001',
        roomType: '2-Seater',
        pricePerBed: 18000,
        checkInDate: DateTime.now(),
        checkOutDate: DateTime.now().add(const Duration(days: 90)),
        status: 'checked-in',
        numberOfBeds: 1,
        totalPrice: 1620000,
        bookingDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ],
  );
}
