class BussinessModel {
  String? id;
  String? businessName;
  String? ownerName;
  String? mobile;
  String? email;
  int? sehrCode;
  double? lat;
  double? lon;
  String? about;
  String? categoryId;
  String? logo;
  String? refferalCode;
  BussinessModel(
      {this.id,
      this.businessName,
      this.ownerName,
      this.mobile,
      this.email,
      this.sehrCode,
      this.lat,
      this.lon,
      this.about,
      this.categoryId,
      this.logo,
      this.refferalCode});

  factory BussinessModel.fromJson(Map<String, dynamic> json) {
    return BussinessModel(
      id: json['_id'],
      businessName: json['businessName'],
      ownerName: json['ownerName'],
      mobile: json['mobile'],
      email: json['email'],
      sehrCode: json['sehrCode'],
      lat: json['lat'],
      lon: json['lon'],
      about: json['about'],
      categoryId: json['categoryId'].toString(),
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'businessName': businessName,
      'ownerName': ownerName,
      'mobile': mobile,
      'email': email,
      'sehrCode': sehrCode,
      'lat': lat,
      'lon': lon,
      'about': about,
      'categoryId': categoryId,
      'logo': logo,
    };
  }
}
