import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sehr_remake/model/order_model.dart';
import 'package:sehr_remake/utils/app/constant.dart';
import 'package:http/http.dart' as http;

class OrderController with ChangeNotifier {
  List<OrderModel> _shopOrders = [];
  List<OrderModel> _userOrders = [];

  int totalOrders = 0;

  int get TotalOrders => totalOrders;

  List<OrderModel> get shopOrders {
    return [..._shopOrders];
  }

  List<OrderModel> get userOrders {
    return [..._userOrders];
  }

  Future<void> getShopOrders(String id) async {
    try {
      var response = await http.get(
          Uri.parse("${Constants.BASE_URL}${Constants.GET_SHOP_ORDERS}/$id"));
      print("resposne : ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['orders'];
        _shopOrders = data.map((e) => OrderModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getTotalShopOrders(String id) async {
    try {
      var response = await http.get(Uri.parse(
          "${Constants.BASE_URL}${Constants.GET_SHOP_ORDERS}/totalOrders/$id"));
      print("resposne : ${response.body}");
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body)['message'];
        totalOrders = data as int;
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getUserOrderModel(String? id) async {
    try {
      var response = await http.get(
          Uri.parse("${Constants.BASE_URL}${Constants.GET_USER_ORDERS}/$id"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['orders'];

        List<OrderModel> orders =
            data.map((e) => OrderModel.fromJson(e)).toList();

        _userOrders = orders;
        print(_shopOrders);
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> orderRequestConformation(String id, String status, int index,
      String categoryId, String shopId, int amount) async {
    print(id);
    String res = "";
    try {
      var response = await http.patch(
          Uri.parse(
              "${Constants.BASE_URL}${Constants.UPDATE_ORDER_STATUS}/$id"),
          body: jsonEncode({
            "status": status,
            "catId": categoryId,
            "shopId": shopId,
            "amount": amount
          }),
          headers: {'Content-Type': 'application/json'});
      print(response.body);
      if (response.statusCode == 200) {
        removeOrderFromList(index);
        res = "Order $status successfully";
      }
    } catch (e) {
      res = "error occured : ${e.toString()}";
    }
    return res;
  }

  void removeOrderFromList(int index) {
    _shopOrders.removeAt(index);
    notifyListeners();
  }
}
