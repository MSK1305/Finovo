import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finovo/providers/transaction_provider.dart';
import 'package:finovo/providers/auth_provider.dart';
import 'package:finovo/providers/budget_provider.dart';
import 'package:finovo/widgets/pie_chart_widget.dart';
import 'package:finovo/widgets/bar_chart_widget.dart';
import 'package:finovo/screens/transactions/add_transaction_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:finovo/utils/export_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).listenToTransactions();
    Provider.of<BudgetProvider>(context, listen: false).listenToBudgets();
  }

  @override
  Widget build(BuildContext context) {
    final txnProvider = Provider.of<TransactionProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final budgetProvider = Provider.of<BudgetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finovo Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "Export Transactions",
            onPressed: () async {
              try {
                await ExportService.exportToCSV(txnProvider.transactions);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('CSV export successful ✅')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
          ),
          IconButton(
            onPressed: auth.logout,
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildSummaryCard(txnProvider),
            PieChartWidget(
              dataMap: txnProvider.getExpenseByCategory(),
              title: "Expense by Category",
            ),
            PieChartWidget(
              dataMap: txnProvider.getIncomeByCategory(),
              title: "Income by Category",
            ),
            BarChartWidget(
              dataMap: txnProvider.getMonthlyExpenses(),
              title: "Monthly Expenses",
            ),
            const SizedBox(height: 10),
            _buildBudgetSection(budgetProvider, txnProvider),
          ],
        ),
      ),
    );
  }

  /// 🔹 Balance Summary Section
  Widget _buildSummaryCard(TransactionProvider txn) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Balance: ₹${txn.balance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Income: ₹${txn.totalIncome.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
            Text(
              'Expense: ₹${txn.totalExpense.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Budget Progress Section
  Widget _buildBudgetSection(
    BudgetProvider budgetProvider,
    TransactionProvider txnProvider,
  ) {
    if (budgetProvider.budgets.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "No budgets set yet. Add one to track your spending limits.",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            "Budgets & Alerts",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...budgetProvider.budgets.map((b) {
          final usage = budgetProvider.getUsagePercent(b.category, txnProvider);
          Color color;
          String message = "";

          if (usage >= 1.0) {
            color = Colors.red;
            message = "❌ Overspent! Budget exceeded.";
          } else if (usage >= 0.8) {
            color = Colors.orange;
            message = "⚠️ Warning: 80% of budget reached.";
          } else {
            color = Colors.green;
            message = "✅ Within budget.";
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${b.category} Budget',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearPercentIndicator(
                      lineHeight: 10.0,
                      percent: usage,
                      progressColor: color,
                      backgroundColor: Colors.grey.shade300,
                      animation: true,
                      barRadius: const Radius.circular(8),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${(usage * b.limit).toStringAsFixed(0)} / ₹${b.limit.toStringAsFixed(0)}',
                          style: TextStyle(color: color),
                        ),
                        Text(message, style: TextStyle(color: color)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
