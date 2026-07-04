import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settleup_app/data/repositories/user_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final UserRepository _userRepository = UserRepository();

  User? get currentUser => _auth.currentUser; // 👈 EKLE

  bool isLoading = false;

  Future<String?> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      await _db.collection("users").doc(uid).set({
        "username": username,
        "email": email,
        "createdAt": Timestamp.now(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Bir hata oluştu";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// LOGIN
  Future<String?> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// ŞİFREMİ UNUTTUM
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Bir hata oluştu";
    }
  }

  Map<String, String> userNames = {};
  Future<void> loadUsernames(List<String> uids) async {
    for (var uid in uids) {
      final name = await _userRepository.getUsername(uid);
      userNames[uid] = name;
    }
    notifyListeners();
  }

  Future<String?> addUserByUsername(String groupId, String username) async {
    try {
      final query = await _db
          .collection("users")
          .where("username", isEqualTo: username)
          .get();

      if (query.docs.isEmpty) {
        return "Kullanıcı bulunamadı";
      }

      final uid = query.docs.first.id;

      await _db.collection("groups").doc(groupId).update({
        "members": FieldValue.arrayUnion([uid]),
      });

      return null;
    } catch (e) {
      return "Hata oluştu";
    }
  }
}
