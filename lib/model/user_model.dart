class User {
  String? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? gender;
  String? dob;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? cnic;
  String? education;
  String? address;
  String? tehsil;
  String? district;
  String? division;
  String? province;
  String? avatar;
  bool? isLocked;
  String? package;
  String? specialPackage;
  String? selectedLocationId;
  //List<String>? activatedSpecialPackageIds;
  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.mobile,
      this.email,
      this.gender,
      this.dob,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.cnic,
      this.education,
      this.address,
      this.tehsil,
      this.district,
      this.division,
      this.province,
      this.avatar,
      this.isLocked,
      this.package,
        this.specialPackage,
        this.selectedLocationId
      //this.activatedSpecialPackageIds,

      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        mobile: json['mobile'],
        email: json['email'],
        gender: json['gender'],
        dob: json['dob'],
        isActive: json['isActive'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        cnic: json['cnic'],
        education: json['education'],
        address: json['address'],
        tehsil: json['tehsil'],
        district: json['district'],
        division: json['division'],
        province: json['province'],
        avatar: json['avatar'],
        isLocked: json['isLocked'],
        package: json['package'],
        specialPackage: json['specialPackage'],
      // activatedSpecialPackageIds: json['activatedSpecialPackageIds'] != null
      //     ? List<String>.from(json['activatedSpecialPackageIds'])
      //     : [],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'gender': gender,
      'dob': dob,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'cnic': cnic,
      'education': education,
      'address': address,
      'tehsil': tehsil,
      'district': district,
      'division': division,
      'province': province,
      'avatar': avatar,
      'isLocked': isLocked,
      'package': package,
      //'activatedSpecialPackageIds': activatedSpecialPackageIds,
    };
  }
}
