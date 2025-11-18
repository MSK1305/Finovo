import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finovo/models/transaction_model.dart';
import 'package:finovo/providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  String type = 'expense';
  String category = 'General';

  @override
  Widget build(BuildContext context) {
    final txnProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: 'income', child: Text('Income')),
                DropdownMenuItem(value: 'expense', child: Text('Expense')),
              ],
              onChanged: (v) => setState(() => type = v!),
            ),
            TextField(
              controller: noteCtrl,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (amountCtrl.text.isEmpty) return;

                final txn = TransactionModel(
                  id: '',
                  amount: double.parse(amountCtrl.text),
                  type: type,
                  category: category,
                  date: DateTime.now(),
                  notes: noteCtrl.text,
                );
                await txnProvider.addTransaction(txn);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
