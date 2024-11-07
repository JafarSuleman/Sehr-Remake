class CommissionModel {
  String? id;
  int? commission;
  int? totalSale;

  CommissionModel({this.id, this.commission, this.totalSale});

  CommissionModel.fromJson(Map json) {
    id = json['_id'];
    commission = json['commission'];
    totalSale = json['totalSale'];
  }
}
