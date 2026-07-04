import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getUsername(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    return doc.data()?['username'] ?? "?";
  }

  Future<String?> findUserByUserName(String username) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.id;
  }
}
