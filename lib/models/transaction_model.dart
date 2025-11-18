import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final DateTime date;
  final String notes;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'category': category,
      'date': Timestamp.fromDate(date),
      'notes': notes,
    };
  }

  factory TransactionModel.fromMap(String id, Map<String, dynamic> map) {
    return TransactionModel(
      id: id,
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? '',
      category: map['category'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      notes: map['notes'] ?? '',
    );
  }
}
