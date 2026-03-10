import 'package:cloud_firestore/cloud_firestore.dart';

/// Service class for reading data from Firestore collections and documents.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ----------------------------
  // Read all documents from a collection
  // ----------------------------
  Stream<QuerySnapshot> getCollection(String collectionPath) {
    return _db.collection(collectionPath).snapshots();
  }

  // ----------------------------
  // Read a single document by ID
  // ----------------------------
  Future<DocumentSnapshot> getDocument(String collectionPath, String docId) {
    return _db.collection(collectionPath).doc(docId).get();
  }

  // ----------------------------
  // Read collection with ordering
  // ----------------------------
  Stream<QuerySnapshot> getCollectionOrdered(
    String collectionPath, {
    required String orderBy,
    bool descending = false,
  }) {
    return _db
        .collection(collectionPath)
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }

  // ----------------------------
  // Read collection with a filter (where clause)
  // ----------------------------
  Stream<QuerySnapshot> getCollectionWhere(
    String collectionPath, {
    required String field,
    required dynamic isEqualTo,
  }) {
    return _db
        .collection(collectionPath)
        .where(field, isEqualTo: isEqualTo)
        .snapshots();
  }

  // ----------------------------
  // Read a subcollection from a document
  // ----------------------------
  Stream<QuerySnapshot> getSubcollection(
    String parentCollection,
    String docId,
    String subcollection,
  ) {
    return _db
        .collection(parentCollection)
        .doc(docId)
        .collection(subcollection)
        .snapshots();
  }
}
