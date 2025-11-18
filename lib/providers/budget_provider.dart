import 'package:flutter/material.dart';
import 'package:finovo/models/budget_model.dart';
import 'package:finovo/services/firestore_service.dart';
import 'package:finovo/providers/transaction_provider.dart';

class BudgetProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  List<BudgetModel> _budgets = [];

  List<BudgetModel> get budgets => _budgets;

  void listenToBudgets() {
    _firestore.getBudgets().listen((data) {
      _budgets = data;
      notifyListeners();
    });
  }

  Future<void> addBudget(BudgetModel b) async {
    await _firestore.addBudget(b);
  }

  /// Check budget usage per category
  double getUsagePercent(String category, TransactionProvider txnProvider) {
    final budget = _budgets.firstWhere(
      (b) => b.category == category && b.isActive,
      orElse: () => BudgetModel(
        id: '',
        category: category,
        limit: 0,
        startDate: DateTime.now(),
        isActive: false,
      ),
    );

    if (budget.limit == 0) return 0;

    final spent = txnProvider.transactions
        .where((t) => t.category == category && t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    return (spent / budget.limit).clamp(0.0, 1.0);
  }
}
