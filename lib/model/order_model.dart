class OrderModel {
  String? shopid;
  String? userid;
  int? amount;
  String? status;
  String? date;
  String? id;

  OrderModel(
      {this.shopid, this.userid, this.amount, this.status, this.date, this.id});

  OrderModel.fromJson(Map<String, dynamic> json) {
    print("Order Model Data ==> ${json.toString()}");
    shopid = json['shopid'];
    userid = json['userid'];
    amount = json['amount'];
    status = json['status'];
    date = json['date'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['shopid'] = shopid;
    data['userid'] = userid;
    data['amount'] = amount;
    data['status'] = status;
    data['date'] = date;
    data['_id'] = id;
    return data;
  }
}
