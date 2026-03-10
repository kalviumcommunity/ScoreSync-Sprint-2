import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/functions/functions.dart';

// ----------------------------
// Players List – Reads from 'players' collection
// ----------------------------
class PlayersScreen extends StatelessWidget {
  PlayersScreen({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Players")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getCollectionOrdered(
          'players',
          orderBy: 'name',
        ),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "No players found.\nAdd players to the 'players' collection in Firestore.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Data loaded – build list
          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              final name = data['name'] ?? 'Unknown';
              final position = data['position'] ?? '';
              final teamId = data['teamId'] ?? '';

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      name.toString().isNotEmpty
                          ? name.toString()[0].toUpperCase()
                          : '?',
                    ),
                  ),
                  title: Text(name.toString()),
                  subtitle: Text(
                    position.toString().isNotEmpty
                        ? "$position • Team: $teamId"
                        : "ID: $docId",
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to player detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerDetailScreen(
                          collectionPath: 'players',
                          docId: docId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ----------------------------
// Player Detail – Reads a single document
// ----------------------------
class PlayerDetailScreen extends StatelessWidget {
  final String collectionPath;
  final String docId;

  PlayerDetailScreen({
    super.key,
    required this.collectionPath,
    required this.docId,
  });

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Player Details")),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestoreService.getDocument(collectionPath, docId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Document not found."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Text(
                      (data['name'] ?? '?').toString()[0].toUpperCase(),
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Display all fields from the document
                ...data.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(entry.value.toString()),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ----------------------------
// Matches List – Reads from 'matches' collection
// ----------------------------
class MatchesScreen extends StatelessWidget {
  MatchesScreen({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Matches")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getCollectionOrdered(
          'matches',
          orderBy: 'date',
          descending: true,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sports_score, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "No matches found.\nAdd matches to the 'matches' collection in Firestore.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final teamA = data['teamA'] ?? 'Team A';
              final teamB = data['teamB'] ?? 'Team B';
              final scoreA = data['scoreA'] ?? 0;
              final scoreB = data['scoreB'] ?? 0;
              final date = data['date'] ?? '';
              final status = data['status'] ?? 'upcoming';

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Match status badge
                      Align(
                        alignment: Alignment.topRight,
                        child: Chip(
                          label: Text(
                            status.toString().toUpperCase(),
                            style: const TextStyle(fontSize: 11),
                          ),
                          backgroundColor: status == 'live'
                              ? Colors.red[100]
                              : status == 'completed'
                                  ? Colors.green[100]
                                  : Colors.orange[100],
                        ),
                      ),
                      // Score display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                teamA.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                scoreA.toString(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "vs",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Column(
                            children: [
                              Text(
                                teamB.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                scoreB.toString(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        date.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
