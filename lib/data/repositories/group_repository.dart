import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:settleup_app/data/models/expense_model.dart';
import 'package:settleup_app/data/models/group_model.dart';

class GroupRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<GroupModel>> getUserGroups(String userId) {
    return _firestore
        .collection("groups")
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return GroupModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<void> createGroup(GroupModel group) async {
    final docRef = await _firestore.collection("groups").add(group.toMap());

    final userId = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.collection("users").doc(userId).set({
      "groups": FieldValue.arrayUnion([docRef.id]),
    }, SetOptions(merge: true));
  }

  Future<void> deleteGroup(GroupModel group) async {
    await _firestore.collection("groups").doc(group.id).delete();
  }

  Future<void> addMemberToGroup(String groupId, String uid) async {
    await FirebaseFirestore.instance.collection("groups").doc(groupId).update({
      "members": FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> addExpense({
    required GroupModel group,
    required String title,
    required double amount,
    required String paidBy,
  }) async {
    final groupRef = FirebaseFirestore.instance
        .collection("groups")
        .doc(group.id);
    final expenseRef = groupRef.collection("expenses").doc();
    final participants = group.members;
    double share = amount / participants.length;
    Map<String, dynamic> updates = {};
    for (var user in participants) {
      if (user == paidBy) {
        updates["balances.$user"] = FieldValue.increment(amount - share);
      } else {
        updates["balances.$user"] = FieldValue.increment(-share);
      }
    }

    //  expense kaydet
    await expenseRef.set({
      "title": title,
      "amount": amount,
      "paidBy": paidBy,
      "participants": participants,
      "date": Timestamp.now(),
    });

    //  balance güncelle
    await groupRef.update(updates);
  }
}
