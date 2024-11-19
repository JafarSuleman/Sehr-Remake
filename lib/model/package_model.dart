class PackageModel {
  final String id;
  final String title;
  final double? salesTarget;
  final String description;

  PackageModel({
    required this.id,
    required this.title,
    this.salesTarget,
    required this.description,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    print("Package Model ===> ${json.toString()}");
    return PackageModel(
      id: json['_id'],
      title: json['title'],
      salesTarget: json['salesTarget']?.toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'salesTarget': salesTarget,
      'description': description,
    };
  }
}
