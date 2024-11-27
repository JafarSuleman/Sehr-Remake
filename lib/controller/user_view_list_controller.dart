import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/user_table_model.dart';
import '../utils/app/constant.dart';

class UserTableController extends GetxController {
  RxList<SpecialPackageUserModel> users = <SpecialPackageUserModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchUsersBySpecialPackage(String packageId, String type) async {
    isLoading.value = true;
    final url = '${Constants.BASE_URL}${Constants.FETCH_USER_BY_SPECIAL_ID}/$packageId?type=$type';
    try {
      final response = await http.get(Uri.parse(url));
      print("API URL: $url"); // Log the request URL

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("Response Data: $responseData"); // Log the entire response data

        // Check if 'data' field exists and is not empty
        if (responseData.containsKey('data') && responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];

          // Parse and update users list
          users.value = data.map((json) => SpecialPackageUserModel.fromJson(json)).toList();
          print("Fetched users: ${users.length}");
        } else {
          print("No users found or 'data' field missing in response.");
        }
      } else {
        print("Failed to load users. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
