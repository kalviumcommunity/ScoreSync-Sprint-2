import 'dart:async';
import 'package:flutter/material.dart';
import '../functions/scoreFunctions.dart';
import '../models/score_item.dart';

/// ChangeNotifier that manages score items for the current user,
/// providing reactive state to the widget tree via Provider.
class ScoreProvider extends ChangeNotifier {
  final ScoreFunctions _scoreFunctions = ScoreFunctions();

  List<ScoreItem> _scores = [];
  List<ScoreItem> get scores => _scores;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  StreamSubscription? _subscription;

  // ───────────────── Real-time listener ─────────────────

  /// Starts listening to the Firestore scores collection for [userId].
  /// Call this once when the user logs in / the home screen mounts.
  void listenToScores(String userId) {
    _subscription?.cancel();
    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription = _scoreFunctions.getScoresStream(userId).listen(
      (items) {
        _scores = items;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Cancels the Firestore listener (e.g. on logout).
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _scores = [];
    notifyListeners();
  }

  // ───────────────── CREATE ─────────────────

  Future<void> addScore(ScoreItem item) async {
    try {
      await _scoreFunctions.createScore(item);
      // The stream listener will automatically pick up the new doc.
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ───────────────── UPDATE ─────────────────

  Future<void> updateScore(ScoreItem item) async {
    try {
      await _scoreFunctions.updateScore(item);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ───────────────── DELETE ─────────────────

  Future<void> deleteScore(String docId) async {
    try {
      await _scoreFunctions.deleteScore(docId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ───────────────── Cleanup ─────────────────

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
