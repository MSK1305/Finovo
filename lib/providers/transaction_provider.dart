import 'package:flutter/material.dart';
import 'package:finovo/models/transaction_model.dart';
import 'package:finovo/services/firestore_service.dart';
import 'package:intl/intl.dart';

class TransactionProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  double get totalIncome => _transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  void listenToTransactions() {
    _firestoreService.getTransactions().listen((data) {
      _transactions = data;
      notifyListeners();
    });
  }

  Future<void> addTransaction(TransactionModel txn) async {
    await _firestoreService.addTransaction(txn);
  }

  Future<void> deleteTransaction(String id) async {
    await _firestoreService.deleteTransaction(id);
  }

  /// Chart: Expense by category
  Map<String, double> getExpenseByCategory() {
    final Map<String, double> data = {};
    for (var txn in _transactions.where((t) => t.type == 'expense')) {
      data[txn.category] = (data[txn.category] ?? 0) + txn.amount;
    }
    return data;
  }

  /// Chart: Income by category
  Map<String, double> getIncomeByCategory() {
    final Map<String, double> data = {};
    for (var txn in _transactions.where((t) => t.type == 'income')) {
      data[txn.category] = (data[txn.category] ?? 0) + txn.amount;
    }
    return data;
  }

  /// Chart: Expense by month
  Map<String, double> getMonthlyExpenses() {
    final Map<String, double> monthly = {};
    for (var txn in _transactions.where((t) => t.type == 'expense')) {
      String month = DateFormat('MMM yyyy').format(txn.date);
      monthly[month] = (monthly[month] ?? 0) + txn.amount;
    }
    return monthly;
  }
}
