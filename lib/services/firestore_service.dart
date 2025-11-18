import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finovo/models/transaction_model.dart';
import 'package:finovo/models/budget_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirestoreService() {
    // ✅ Enable offline persistence
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  String get uid => _auth.currentUser!.uid;

  // ========== TRANSACTIONS ==========

  CollectionReference get _transactionsRef =>
      _firestore.collection('users').doc(uid).collection('transactions');

  // Add transaction
  Future<void> addTransaction(TransactionModel txn) async {
    await _transactionsRef.add(txn.toMap());
  }

  // Add transaction with custom ID
  Future<void> addTransactionWithId(TransactionModel txn) async {
    await _transactionsRef.doc(txn.id).set(txn.toMap());
  }

  // Update transaction
  Future<void> updateTransaction(TransactionModel txn) async {
    await _transactionsRef.doc(txn.id).update(txn.toMap());
  }

  // Delete transaction
  Future<void> deleteTransaction(String id) async {
    await _transactionsRef.doc(id).delete();
  }

  // Get single transaction
  Future<TransactionModel?> getTransaction(String id) async {
    final doc = await _transactionsRef.doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return TransactionModel.fromMap(doc.id, data);
    }
    return null;
  }

  // Stream all transactions
  Stream<List<TransactionModel>> getTransactions() {
    return _transactionsRef.orderBy('date', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  // Stream transactions for specific month
  Stream<List<TransactionModel>> getTransactionsForMonth(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    // NOTE: This assumes you store 'date' as a Firestore Timestamp.
    // If you store date as ISO string, adjust the comparisons accordingly.
    return _transactionsRef
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TransactionModel.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
        });
  }

  // Stream transactions by type
  Stream<List<TransactionModel>> getTransactionsByType(String type) {
    return _transactionsRef
        .where('type', isEqualTo: type)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TransactionModel.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
        });
  }

  // ========== BUDGETS ==========

  CollectionReference get _budgetsRef =>
      _firestore.collection('users').doc(uid).collection('budgets');

  // Add budget
  Future<void> addBudget(BudgetModel budget) async {
    await _budgetsRef.add(budget.toMap());
  }

  // Add budget with custom ID
  Future<void> addBudgetWithId(BudgetModel budget) async {
    await _budgetsRef.doc(budget.id).set(budget.toMap());
  }

  // Update budget
  Future<void> updateBudget(BudgetModel budget) async {
    await _budgetsRef.doc(budget.id).update(budget.toMap());
  }

  // Delete budget
  Future<void> deleteBudget(String id) async {
    await _budgetsRef.doc(id).delete();
  }

  // Get single budget
  Future<BudgetModel?> getBudget(String id) async {
    final doc = await _budgetsRef.doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return BudgetModel.fromMap(doc.id, data);
    }
    return null;
  }

  // Stream all budgets
  Stream<List<BudgetModel>> getBudgets() {
    return _budgetsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BudgetModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Stream budgets for specific month
  Stream<List<BudgetModel>> getBudgetsForMonth(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    // NOTE: Adjust filters based on how you store the budget's month/date
    return _budgetsRef
        .where('month', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('month', isLessThanOrEqualTo: end.toIso8601String())
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return BudgetModel.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
        });
  }

  // ========== USER PROFILE ==========

  CollectionReference get _usersRef => _firestore.collection('users');

  // Create or update user profile
  Future<void> setUserProfile(Map<String, dynamic> profile) async {
    await _usersRef.doc(uid).set(profile, SetOptions(merge: true));
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    final doc = await _usersRef.doc(uid).get();
    // Cast doc.data() (Object?) to Map<String, dynamic>?
    return doc.data() as Map<String, dynamic>?;
  }

  // Stream user profile
  Stream<Map<String, dynamic>?> streamUserProfile() {
    return _usersRef
        .doc(uid)
        .snapshots()
        .map((doc) => doc.data() as Map<String, dynamic>?);
  }

  // ========== UTILITY METHODS ==========

  // Check if document exists
  Future<bool> doesTransactionExist(String id) async {
    final doc = await _transactionsRef.doc(id).get();
    return doc.exists;
  }

  // Batch write operations
  Future<void> batchAddTransactions(List<TransactionModel> transactions) async {
    final batch = _firestore.batch();

    for (final txn in transactions) {
      final docRef = _transactionsRef.doc();
      batch.set(docRef, txn.toMap());
    }

    await batch.commit();
  }

  // Clear all user data (for testing/debugging)
  Future<void> clearUserData() async {
    // Delete all transactions
    final transactions = await _transactionsRef.get();
    for (final doc in transactions.docs) {
      await doc.reference.delete();
    }

    // Delete all budgets
    final budgets = await _budgetsRef.get();
    for (final doc in budgets.docs) {
      await doc.reference.delete();
    }
  }
}
