import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sehr_remake/model/business_model.dart';
import 'package:http/http.dart' as http;
import 'package:sehr_remake/utils/app/constant.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import '../model/order_model.dart';

class BussinessController with ChangeNotifier {
  List<BussinessModel> _bussinessModel = [];
  BussinessModel _singleShopdata = BussinessModel();

  List<BussinessModel> get bussinessModel {
    return [..._bussinessModel];
  }

  BussinessModel _singleBussinessData = BussinessModel();

  BussinessModel get singleBussinessData => _singleBussinessData;
  BussinessModel get singleShopData => _singleShopdata;

  Future<void> getBussinesss() async {
    try {
      var response = await http
          .get(Uri.parse("${Constants.BASE_URL}${Constants.GET_BUSSINESS}"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        _bussinessModel = data.map((e) => BussinessModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      print("bussiness ${e.toString()}");
    }
  }

  Future<BussinessModel> getBussinesssById(String id) async {
    BussinessModel bussinessModel = BussinessModel();
    try {
      var response = await http.get(Uri.parse(
          "${Constants.BASE_URL}${Constants.GET_BUSSINESS}/shop/$id"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _singleBussinessData = BussinessModel.fromJson(data);
        print(data);
        bussinessModel = BussinessModel.fromJson(data);
        return bussinessModel;
      }
    } catch (e) {
      print(e.toString());
    }
    return bussinessModel;
  }

  Future<void> getBussinessData(String mobile) async {
    String newMobile = mobile.replaceFirst("+92", "0");
    String res = '';
    try {
      var response = await http.get(Uri.parse(
          "${Constants.BASE_URL}${Constants.GET_BUSSINESS_BYPHONE}/$newMobile"));

      if (response.statusCode == 200) {
        Map<String, dynamic> userJson = jsonDecode(response.body);
        print(userJson);
        _singleShopdata = BussinessModel.fromJson(userJson);
        notifyListeners();
      }
      res = "Got the Data ${response.body}";
    } catch (e) {
      res = e.toString();
    }
  }

  Future<List<BussinessModel>> getSelectedBussiness(
      List<OrderModel> orders) async {
    List<BussinessModel> bussiness = [];

    for (int i = 0; i < orders.length; i++) {
      print(orders[i].amount);
      var singleShop = await getBussinesssById(orders[i].shopid.toString());

      bussiness.add(singleShop);
    }

    return bussiness;
  }

  Future<bool> checkForBussinessData(String mobile) async {
    String phone = mobile.replaceFirst("+92", "0");
    late bool exists;
    try {
      print("checkfor data");
      var response = await http.get(
          Uri.parse("${Constants.BASE_URL}${Constants.GET_BUSSINESS}/$phone"));
      print(response.statusCode);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['exists'] as bool == true) {
          exists = true;
        } else {
          exists = false;
        }
      }
    } catch (e) {
      print(e.toString());
      return exists;
    }
    return exists;
  }

  Future<String> createBussinessData(BussinessModel model, XFile file) async {
    String res = "Somthing Went Wrong";
    try {
      // var response = await http.post(
      //     Uri.parse("${Constants.BASE_URL}/api/v1/user"),
      //     body: jsonEncode(user.toJson()),
      //     headers: {'Content-Type': "multipart/form-data"});
      // Create a multipart request for the server
      var uri = Uri.parse(
          "${Constants.BASE_URL}/api/v1/business"); // Replace with your Node.js server URL
      var request = http.MultipartRequest('POST', uri);

      request.fields['bussinessname'] = model.businessName.toString();
      request.fields['ownername'] = model.ownerName.toString();
      request.fields['mobile'] = FirebaseAuth.instance.currentUser!.phoneNumber
          .toString()
          .replaceFirst("+92", "0", 0);
      request.fields['about'] = model.about.toString();
      request.fields['lat'] = model.lat.toString();
      request.fields['lon'] = model.lon.toString();
      request.fields['categoryId'] = model.categoryId.toString();
      request.fields['refferalCode'] = model.refferalCode.toString();

      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: basename(file.path));

      request.files.add(multipartFile);

      // Send the request and await the response
      var response = await request.send();

      if (response.statusCode == 200) {
        res = "Bussiness Has Been Added";
      } else {
        res = "Failed to Register User ${response.reasonPhrase}";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> updateUserData(String ownerName, String bussinessName,
      XFile? file, String mobile, String imgUrl) async {
    String res = "Somthing Went Wrong";

    try {
      // var response = await http.post(
      //     Uri.parse("${Constants.BASE_URL}/api/v1/user"),
      //     body: jsonEncode(user.toJson()),
      //     headers: {'Content-Type': "multipart/form-data"});
      // Create a multipart request for the server

      var uri = Uri.parse(
          "${Constants.BASE_URL}/api/v1/business/update-image"); // Replace with your Node.js server URL
      var request = http.MultipartRequest('PATCH', uri);

      request.fields['ownerName'] = ownerName;
      request.fields['businessName'] = bussinessName;
      request.fields['mobile'] = mobile;
      request.fields['img'] = imgUrl;

      if (file != null) {
        var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
        var length = await file.length();
        var multipartFile = http.MultipartFile('image', stream, length,
            filename: basename(file.path));

        request.files.add(multipartFile);
      }

      // Send the request and await the response
      var response = await request.send();

      if (response.statusCode == 200) {
        res = "Bussiness has Been Updated";
      } else {
        res = "Failed to Register User ${response.reasonPhrase}";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
