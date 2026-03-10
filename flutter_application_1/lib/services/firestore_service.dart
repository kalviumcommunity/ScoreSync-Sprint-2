// firestore_service.dart
// Handles Firestore CRUD operations for tasks

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Reference to the 'tasks' collection
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  // Add a new task
  Future<void> addTask(String title) {
    return tasks.add({
      'title': title,
      'createdAt': Timestamp.now(),
    });
  }

  // Delete a task by document ID
  Future<void> deleteTask(String docId) {
    return tasks.doc(docId).delete();
  }

  // Get all tasks as a real-time stream (newest first)
  Stream<QuerySnapshot> getTasks() {
    return tasks.orderBy('createdAt', descending: true).snapshots();
  }
}
