class CategoryModel {
  String? id;
  String? title;
  int? commission;

  CategoryModel({this.id, this.title, this.commission});

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['_id'],
      title: map['title'],
      commission: map['commission'],
    );
  }
}
