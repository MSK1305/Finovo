/// category_model.dart
/// --------------------
/// Represents income/expense categories with optional icon and color.
/// Used later for advanced filtering, charts, and category management.

class CategoryModel {
  final String id;
  final String name;
  final String type; // 'income' or 'expense'
  final int colorValue; // store as integer for Firestore
  final String icon; // optional icon reference

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.colorValue,
    this.icon = '',
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'type': type, 'colorValue': colorValue, 'icon': icon};
  }

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      colorValue: map['colorValue'] ?? 0xFF000000,
      icon: map['icon'] ?? '',
    );
  }
}
