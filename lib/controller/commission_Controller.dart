import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sehr_remake/model/commission_model.dart';
import 'package:http/http.dart' as http;
import 'package:sehr_remake/utils/app/constant.dart';

class CommissionController with ChangeNotifier {
  CommissionModel _commission = CommissionModel();

  CommissionModel get commission => _commission;

  Future<void> getCommissionAndSaleDetail(String shopId) async {
    try {
      var response = await http.get(Uri.parse(
          "${Constants.BASE_URL}${Constants.GET_COMMISIONSALE_DETAIL}/$shopId"));

      if (response.statusCode == 200) {
        var packageJson = jsonDecode(response.body);
        _commission = CommissionModel.fromJson(packageJson);
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
