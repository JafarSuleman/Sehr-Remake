import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sehr_remake/model/package_model.dart';
import 'package:http/http.dart' as http;
import 'package:sehr_remake/utils/app/constant.dart';

class PackageController with ChangeNotifier {
  List<PackageModel> _packages = [];
  bool _isLoading = false;

  List<PackageModel> get packages => [..._packages];
  bool get isLoading => _isLoading;

  PackageController() {
    getAllPackages();
  }

  Future<void> getAllPackages() async {
    _isLoading = true;
    notifyListeners();

    try {
      var response = await http.get(Uri.parse("${Constants.BASE_URL}${Constants.GET_PACKAGES}"));
      print("All Packages ===> ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> packageJson = jsonDecode(response.body)['data'];
        _packages = packageJson.map((e) => PackageModel.fromJson(e)).toList();
      } else {
        print("Failed to load packages");
      }
    } catch (e) {
      print("Error fetching packages: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
