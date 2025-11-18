import 'package:flutter/material.dart';
import 'package:finovo/models/transaction_model.dart';

/// TransactionTile
/// ----------------
/// Displays a single transaction (amount, category, type, and notes)
/// Currently minimal — will be useful later for polished UI and swipe actions.
class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onDelete;

  const TransactionTile({super.key, required this.transaction, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = transaction.type == 'income'
        ? Colors.green
        : Colors.redAccent;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(
          transaction.category,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        subtitle: Text(transaction.notes),
        trailing: Text(
          '₹${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
        onLongPress: onDelete,
      ),
    );
  }
}
