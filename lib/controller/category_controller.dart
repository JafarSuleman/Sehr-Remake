import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sehr_remake/model/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:sehr_remake/utils/app/constant.dart';

class CategoryController with ChangeNotifier {
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => [..._categories];

  Future<void> getCategories() async {
    try {
      var response = await http
          .get(Uri.parse("${Constants.BASE_URL}${Constants.GET_CATEGORIES}"));

      if (response.statusCode == 200) {
        List<dynamic> categoryJson = jsonDecode(response.body)['categories'];

        _categories =
            categoryJson.map((e) => CategoryModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
