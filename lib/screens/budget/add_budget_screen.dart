import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finovo/models/budget_model.dart';
import 'package:finovo/providers/budget_provider.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final categoryCtrl = TextEditingController();
  final limitCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Budget')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: categoryCtrl,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: limitCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly Limit (₹)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (categoryCtrl.text.isEmpty || limitCtrl.text.isEmpty) return;
                final budget = BudgetModel(
                  id: '',
                  category: categoryCtrl.text.trim(),
                  limit: double.parse(limitCtrl.text),
                  startDate: DateTime.now(),
                );
                await budgetProvider.addBudget(budget);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
