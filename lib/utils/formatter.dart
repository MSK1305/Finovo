import 'package:intl/intl.dart';

/// formatter.dart
/// ---------------
/// Provides helpers for consistent currency and date formatting across the app.

String formatCurrency(double amount) {
  return '₹${amount.toStringAsFixed(2)}';
}

String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date);
}
