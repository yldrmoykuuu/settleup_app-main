import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settleup_app/data/models/expense_model.dart';
import 'package:settleup_app/data/models/group_model.dart';
import 'package:settleup_app/data/repositories/group_repository.dart';
import 'package:settleup_app/data/repositories/user_repository.dart';

class DashboardViewmodel extends ChangeNotifier {
  final GroupRepository _groupRepository;
  final UserRepository _userRepository = UserRepository();
  DashboardViewmodel(this._groupRepository) {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
      user,
    ) {
      if (user != null) {
        loadGroups();
      } else {
        _subscription?.cancel();
        groups = [];
        isLoading = false;
        notifyListeners();
      }
    });
  }

  List<GroupModel> groups = [];
  bool isLoading = true;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  double get netBalance {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return 0;
    return groups.fold(0.0, (acc, group) => acc + (group.balances[uid] ?? 0));
  }

  double get totalCredit {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return 0;
    return groups.fold(0.0, (acc, group) {
      final balance = group.balances[uid] ?? 0;
      return balance > 0 ? acc + balance : acc;
    });
  }

  double get totalDebt {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return 0;
    return groups.fold(0.0, (acc, group) {
      final balance = group.balances[uid] ?? 0;
      return balance < 0 ? acc + balance : acc;
    });
  }

  StreamSubscription? _subscription;
  StreamSubscription? _authSubscription;

  void loadGroups() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      isLoading = false;
      return;
    }

    _subscription?.cancel();
    _subscription = _groupRepository.getUserGroups(uid).listen((data) {
      groups = data;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addGroup(String name) async {
    final group = GroupModel(
      id: '',
      name: name,
      members: [userId], // 🔥 gerçek user
      balances: {userId: 0},
    );

    await _groupRepository.createGroup(group);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<String?> addUserByUsername(String groupId, String username) async {
    final uid = await _userRepository.findUserByUserName(username);

    if (uid == null) {
      return "Kullanıcı bulunamadı";
    }

    await _groupRepository.addMemberToGroup(groupId, uid);

    return null;
  }

  Future<void> addExpense({
    required GroupModel group,
    required String title,
    required double amount,
    required String paidBy,
  }) async {
    await _groupRepository.addExpense(
      group: group,
      title: title,
      amount: amount,
      paidBy: paidBy,
    );
  }

  Stream<List<ExpenseModel>> getExpenses(String groupId) {
    return FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("expenses")
        .orderBy("date", descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((e) => ExpenseModel.fromFirestore(e)).toList(),
        );
  }
}
