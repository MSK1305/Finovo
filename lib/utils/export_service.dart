import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:finovo/models/transaction_model.dart';

class ExportService {
  /// Converts transactions into CSV and shares it.
  static Future<void> exportToCSV(List<TransactionModel> transactions) async {
    if (transactions.isEmpty) throw Exception("No transactions to export.");

    // Prepare CSV data
    List<List<dynamic>> rows = [
      ['Date', 'Category', 'Type', 'Amount', 'Notes'],
    ];

    for (var t in transactions) {
      rows.add([
        t.date.toIso8601String(),
        t.category,
        t.type,
        t.amount,
        t.notes,
      ]);
    }

    // Convert to CSV string
    String csvData = const ListToCsvConverter().convert(rows);

    // Get app's documents directory
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/finovo_transactions.csv';

    // Write to file
    final file = File(path);
    await file.writeAsString(csvData);

    // Share the file
    await Share.shareXFiles([XFile(path)], text: 'My Finovo transactions');
  }
}
