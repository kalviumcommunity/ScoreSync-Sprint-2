import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single game/match score entry stored in Firestore.
class ScoreItem {
  final String? id;
  final String userId;
  final String title;
  final String sport;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final DateTime date;
  final DateTime createdAt;

  ScoreItem({
    this.id,
    required this.userId,
    required this.title,
    required this.sport,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.date,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Creates a ScoreItem from a Firestore document snapshot.
  factory ScoreItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScoreItem(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      sport: data['sport'] ?? '',
      homeTeam: data['homeTeam'] ?? '',
      awayTeam: data['awayTeam'] ?? '',
      homeScore: data['homeScore'] ?? 0,
      awayScore: data['awayScore'] ?? 0,
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Converts the ScoreItem to a Map for Firestore storage.
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'sport': sport,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Creates a copy with optional field overrides.
  ScoreItem copyWith({
    String? id,
    String? userId,
    String? title,
    String? sport,
    String? homeTeam,
    String? awayTeam,
    int? homeScore,
    int? awayScore,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return ScoreItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      sport: sport ?? this.sport,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
