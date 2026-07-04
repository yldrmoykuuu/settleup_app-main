import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final String paidBy;
  final DateTime date;
  final List<String> participants;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.date,
    required this.participants,
  });
  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      title: data["title"],
      amount: (data["amount"] as num).toDouble(),
      paidBy: data["paidBy"],
      participants: List<String>.from(data["participants"]),
      date: (data["date"] as Timestamp).toDate(),
    );
  }
}
