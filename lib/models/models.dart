class Court {
  final String id;
  final String name;
  final String location;
  final String address;
  final double rating;
  final int reviews;
  final double pricePerHour;
  final String surface;
  final bool isIndoor;
  final bool hasLighting;
  final List<String> amenities;
  final String emoji;

  const Court({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.rating,
    required this.reviews,
    required this.pricePerHour,
    required this.surface,
    required this.isIndoor,
    required this.hasLighting,
    required this.amenities,
    required this.emoji,
  });
}

class TimeSlot {
  final String time;
  final bool isAvailable;

  const TimeSlot({required this.time, required this.isAvailable});
}

class Booking {
  final String id;
  final Court court;
  final DateTime date;
  final String time;
  final double totalAmount;
  final String status; // confirmed, pending, cancelled

  const Booking({
    required this.id,
    required this.court,
    required this.date,
    required this.time,
    required this.totalAmount,
    required this.status,
  });
}

// Sample Data
final List<Court> sampleCourts = [
  const Court(
    id: '1',
    name: 'Platinum Court',
    location: 'Al Olaya, Riyadh',
    address: 'King Fahd Rd, Al Olaya, Riyadh',
    rating: 4.9,
    reviews: 312,
    pricePerHour: 120,
    surface: 'Artificial Grass',
    isIndoor: true,
    hasLighting: true,
    amenities: ['Locker Rooms', 'Showers', 'Café', 'Parking', 'Pro Shop'],
    emoji: '🏟',
  ),
  const Court(
    id: '2',
    name: 'The Arena',
    location: 'Hittin, Riyadh',
    address: 'Anas Ibn Malik Rd, Hittin',
    rating: 4.7,
    reviews: 198,
    pricePerHour: 90,
    surface: 'Artificial Grass',
    isIndoor: false,
    hasLighting: true,
    amenities: ['Parking', 'Café', 'Equipment Rental'],
    emoji: '🎾',
  ),
  const Court(
    id: '3',
    name: 'Sky Court',
    location: 'Al Nakheel, Riyadh',
    address: 'Prince Mohammed Rd, Al Nakheel',
    rating: 4.8,
    reviews: 245,
    pricePerHour: 150,
    surface: 'Premium Turf',
    isIndoor: true,
    hasLighting: true,
    amenities: ['Locker Rooms', 'Showers', 'Sauna', 'Café', 'Parking'],
    emoji: '⭐',
  ),
  const Court(
    id: '4',
    name: 'Green Zone',
    location: 'Al Malqa, Riyadh',
    address: 'Al Malqa District, North Riyadh',
    rating: 4.5,
    reviews: 89,
    pricePerHour: 75,
    surface: 'Artificial Grass',
    isIndoor: false,
    hasLighting: true,
    amenities: ['Parking', 'Equipment Rental'],
    emoji: '🌿',
  ),
];

List<TimeSlot> generateTimeSlots() {
  final slots = <TimeSlot>[];
  final unavailable = ['10:00 AM', '11:00 AM', '3:00 PM', '6:00 PM', '7:00 PM'];
  final times = [
    '7:00 AM', '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM',
    '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM',
  ];
  for (final t in times) {
    slots.add(TimeSlot(time: t, isAvailable: !unavailable.contains(t)));
  }
  return slots;
}

final List<Booking> sampleBookings = [
  Booking(
    id: 'BK001',
    court: sampleCourts[0],
    date: DateTime.now().add(const Duration(days: 2)),
    time: '5:00 PM',
    totalAmount: 120,
    status: 'confirmed',
  ),
  Booking(
    id: 'BK002',
    court: sampleCourts[2],
    date: DateTime.now().add(const Duration(days: 7)),
    time: '8:00 AM',
    totalAmount: 150,
    status: 'confirmed',
  ),
  Booking(
    id: 'BK003',
    court: sampleCourts[1],
    date: DateTime.now().subtract(const Duration(days: 5)),
    time: '4:00 PM',
    totalAmount: 90,
    status: 'confirmed',
  ),
];