import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/score_item.dart';

/// Handles all Firestore CRUD operations for the `scores` collection.
class ScoreFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Reference to the top-level `scores` collection.
  CollectionReference get _scoresRef => _firestore.collection('scores');

  // ───────────────────────── CREATE ─────────────────────────

  /// Adds a new score item to Firestore. Returns the generated document ID.
  Future<String> createScore(ScoreItem item) async {
    try {
      final docRef = await _scoresRef.add(item.toFirestore());
      return docRef.id;
    } catch (e) {
      throw 'Failed to create score: $e';
    }
  }

  // ───────────────────────── READ ───────────────────────────

  /// Returns a real-time stream of score items for a specific user,
  /// ordered by date descending.
  Stream<List<ScoreItem>> getScoresStream(String userId) {
    return _scoresRef
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ScoreItem.fromFirestore(doc)).toList());
  }

  /// Fetches all score items for a specific user once (non-realtime).
  Future<List<ScoreItem>> getScores(String userId) async {
    try {
      final snapshot = await _scoresRef
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ScoreItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Failed to fetch scores: $e';
    }
  }

  /// Fetches a single score item by its document ID.
  Future<ScoreItem?> getScoreById(String docId) async {
    try {
      final doc = await _scoresRef.doc(docId).get();
      if (!doc.exists) return null;
      return ScoreItem.fromFirestore(doc);
    } catch (e) {
      throw 'Failed to fetch score: $e';
    }
  }

  // ───────────────────────── UPDATE ─────────────────────────

  /// Updates an existing score item in Firestore.
  Future<void> updateScore(ScoreItem item) async {
    if (item.id == null) throw 'Cannot update a score without an ID';
    try {
      await _scoresRef.doc(item.id).update(item.toFirestore());
    } catch (e) {
      throw 'Failed to update score: $e';
    }
  }

  // ───────────────────────── DELETE ─────────────────────────

  /// Deletes a score item by its document ID.
  Future<void> deleteScore(String docId) async {
    try {
      await _scoresRef.doc(docId).delete();
    } catch (e) {
      throw 'Failed to delete score: $e';
    }
  }
}
