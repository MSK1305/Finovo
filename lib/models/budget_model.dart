class BudgetModel {
  final String id;
  final String category;
  final double limit;
  final DateTime startDate; // For monthly budget tracking
  final bool isActive;

  BudgetModel({
    required this.id,
    required this.category,
    required this.limit,
    required this.startDate,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'limit': limit,
      'startDate': startDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory BudgetModel.fromMap(String id, Map<String, dynamic> map) {
    return BudgetModel(
      id: id,
      category: map['category'] ?? '',
      limit: (map['limit'] ?? 0).toDouble(),
      startDate: DateTime.parse(map['startDate']),
      isActive: map['isActive'] ?? true,
    );
  }
}
