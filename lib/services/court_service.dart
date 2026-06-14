import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class CourtService {
  CourtService._();
  static final CourtService instance = CourtService._();

  final _db = FirebaseFirestore.instance;
  final _courtsRef = FirebaseFirestore.instance.collection('courts');

  // ─── Fetch all courts ───────────────────────────────────────
  Future<List<Court>> getCourts() async {
    final snapshot = await _courtsRef
        .orderBy('rating', descending: true)
        .get();
    return snapshot.docs.map((doc) => Court.fromFirestore(doc)).toList();
  }

  // ─── Real-time stream of all courts ────────────────────────
  Stream<List<Court>> watchCourts() {
    return _courtsRef
        .orderBy('rating', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Court.fromFirestore(doc)).toList());
  }

  // ─── Fetch single court by ID ───────────────────────────────
  Future<Court?> getCourtById(String id) async {
    final snapshot = await _courtsRef
        .where('id', isEqualTo: id)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Court.fromFirestore(snapshot.docs.first);
  }

  // ─── Filter by indoor/outdoor ───────────────────────────────
  Future<List<Court>> getCourtsByType({required bool isIndoor}) async {
    final snapshot = await _courtsRef
        .where('isIndoor', isEqualTo: isIndoor)
        .orderBy('rating', descending: true)
        .get();
    return snapshot.docs.map((doc) => Court.fromFirestore(doc)).toList();
  }

  // ─── Search by name ─────────────────────────────────────────
  // Firestore doesn't support full-text search natively.
  // We fetch all and filter client-side for now.
  // Replace with Algolia later for production-grade search.
  Future<List<Court>> searchCourts(String query) async {
    final all = await getCourts();
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return all;
    return all.where((court) {
      return court.name.toLowerCase().contains(q) ||
          court.location.toLowerCase().contains(q) ||
          court.address.toLowerCase().contains(q);
    }).toList();
  }

  // ─── Top rated courts ───────────────────────────────────────
  Future<List<Court>> getTopRated({int limit = 5}) async {
    final snapshot = await _courtsRef
        .orderBy('rating', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => Court.fromFirestore(doc)).toList();
  }
}