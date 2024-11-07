class SpecialPackageUserModel {
  final String id;
  final String name;
  final String address;
  final int totalSpendings;

  SpecialPackageUserModel({
    required this.id,
    required this.name,
    required this.address,
    required this.totalSpendings,
  });

  factory SpecialPackageUserModel.fromJson(Map<String, dynamic> json) {
    return SpecialPackageUserModel(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      totalSpendings: json['totalSpendings'] ?? 0,
    );
  }
}
