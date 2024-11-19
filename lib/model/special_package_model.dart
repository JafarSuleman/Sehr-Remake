class SpecialPackageModel {
  final String id;
  final String type;
  final String title;
  final double? salesTarget;
  final String description;
  final String description2;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  SpecialPackageModel({
    required this.id,
    required this.type,
    required this.title,
    required this.salesTarget,
    required this.description,
    required this.description2,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SpecialPackageModel.fromJson(Map<String, dynamic> json) {
    return SpecialPackageModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      salesTarget: _parseDouble(json['salesTarget']),
      description: json['description'] ?? '',
      description2: json['description2'] ?? '',
      note: json['note'] ?? "",
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Helper function to handle double conversion from String or int
  static double? _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
