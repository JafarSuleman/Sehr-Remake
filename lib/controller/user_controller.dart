import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import '../model/order_model.dart';
import '../model/user_model.dart' as UserM;
import '../utils/app/constant.dart';

class UserController with ChangeNotifier {
  UserM.User _userModel = UserM.User();
  UserM.User get userModel => _userModel;

  Future<bool> sendEmailOTP(String email) async {
    try {
      var response = await http.post(
        Uri.parse('${Constants.BASE_URL}${Constants.SEND_OTP_EMAIL}'),
        body: jsonEncode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('OTP sent successfully');
        return true;
      } else {
        print('Failed to send OTP. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending email OTP: $e');
      return false;
    }
  }


  Future<bool> verifyEmailOTP( String otp) async {
    try {
      var response = await http.post(
        Uri.parse('${Constants.BASE_URL}${Constants.VERIFY_OTP_EMAIL}'),
        body: jsonEncode({'otp': otp}),
        headers: {'Content-Type': 'application/json'},
      );
      print('email verified successfully');

      return response.statusCode == 200;
    } catch (e) {
      print('Error verifying email OTP: $e');
      return false;
    }
  }

  // Modify existing methods to handle email
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getUserData(String identifier, BuildContext context) async {
    _isLoading = true;
    notifyListeners(); // Notify UI to show a loading indicator

    print("Identifier ===> $identifier");

    try {
      var response;
      if (identifier.contains('@')) {
        response = await http.post(
          Uri.parse("${Constants.BASE_URL}${Constants.FIND_USER_PROFILE}"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": identifier}),
        );
      } else {
        response = await http.post(
          Uri.parse("${Constants.BASE_URL}${Constants.FIND_USER_PROFILE}"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"phoneNumber": identifier}),
        );
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        Map<String, dynamic> userJson = responseJson['data'];

        _userModel = UserM.User.fromJson(userJson);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading is complete
    }
  }



  Future<bool> checkIfUserExists(String identifier) async {
    print("Identifies in API ===> $identifier");
    bool exists = false;
    try {
      var response;

      if (identifier.contains('@')) {
        // For email identifier, use a POST request with identifier in the body
        response = await http.post(
          Uri.parse("${Constants.BASE_URL}${Constants.CHECK_PROFILE_EXISTS_BY_EMAIL}"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": identifier}),
        );
      } else {
        // For other cases, continue with the original GET request
        response = await http.get(
          Uri.parse("${Constants.BASE_URL}${Constants.CHECK_PROFILE_EXISTS}/$identifier"),
        );
      }

      print("Response Code ==>${response.statusCode}");
      print("Response Body ==> ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Check if 'status' field is true
        if ((identifier.contains('@') && responseBody['status'] == true) ||
            (!identifier.contains('@') && responseBody['exists'] == true)) {
          exists = true;
        } else {
          print("Warning: 'status' or 'exists' field is false in the response.");
        }

      }
    } catch (e) {
      print("Error ==> ${e.toString()}");
    }

    return exists;
  }



  Future<bool> checkIfPhoneExists(String mobile) async {
    late bool exists;
    try {
      print("checkfor data");
      var response = await http.get(Uri.parse(
          "${Constants.BASE_URL}${Constants.CHECK_PROFILE_EXISTS}/$mobile"));
      print(response.statusCode);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['exists'] as bool == true) {
          print(response.body);
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

  // Method to add activated special package ID
  // Future<void> addActivatedSpecialPackageId(String packageId) async {
  //   try {
  //     if (userModel.activatedSpecialPackageIds == null) {
  //       userModel.activatedSpecialPackageIds = [];
  //     }
  //     if (!userModel.activatedSpecialPackageIds!.contains(packageId)) {
  //       userModel.activatedSpecialPackageIds!.add(packageId);
  //
  //       // Update on the server
  //       final response = await http.put(
  //         Uri.parse('${Constants.BASE_URL}/api/users/${userModel.id}'),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode({'activatedSpecialPackageIds': userModel.activatedSpecialPackageIds}),
  //       );
  //       if (response.statusCode == 200) {
  //         notifyListeners();
  //       } else {
  //         print('Failed to update user data');
  //       }
  //     }
  //   } catch (e) {
  //     print('Error updating user data: $e');
  //   }
  // }

  Future<String> createUserData(UserM.User user, XFile file) async {
    String res = "Something Went Wrong";
    try {
      // Initialize the request to the API endpoint
      var uri = Uri.parse("${Constants.BASE_URL}${Constants.CREATE_USER}");
      var request = http.MultipartRequest('POST', uri);

      // Use email from user object if available
      if (user.email != null && user.email!.isNotEmpty) {
        request.fields['email'] = user.email!;
        print("Email being sent: ${user.email}");
      } else {
        print("No email provided.");
      }


      // Add other fields to the request
      request.fields['firstName'] = user.firstName.toString();
      request.fields['lastName'] = user.lastName.toString();
      request.fields['mobile'] = user.mobile.toString();
      request.fields['cnic'] = user.cnic.toString();
      request.fields['address'] = user.address.toString();
      request.fields['education'] = user.education.toString();
      request.fields['district'] = user.district.toString();
      request.fields['division'] = user.division.toString();
      request.fields['province'] = user.province.toString();
      request.fields['tehsil'] = user.tehsil.toString();
      request.fields['gender'] = user.gender.toString();
      request.fields['dob'] = user.dob.toString();
      request.fields['package'] = user.package.toString();


      if (user.package == null) {
        request.fields['specialPackage'] = user.specialPackage.toString();
        request.fields['location'] = user.selectedLocationId.toString();
        print("location Id send: ${user.selectedLocationId.toString()}");
        print("specialPackage Id send: ${user.selectedLocationId.toString()}");
      } else {
        print("Normal package activated");
      }

      print("Data being sent to API:");
      request.fields.forEach((key, value) {
        print("$key: $value");
      });

      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var multipartFile = http.MultipartFile('avatar', stream, length, filename: basename(file.path));
      request.files.add(multipartFile);

      print("File being sent: ${file.path}, Size: $length bytes");

      var response = await request.send();
      print("Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        res = "User has Been Registered";
      } else {
        final responseBody = await response.stream.bytesToString();
        print("Error Status Code: ${response.statusCode}");
        print("Error Reason: ${response.reasonPhrase}");
        print("Error Response Body: $responseBody");

        res = "Failed to Register User: ${response.reasonPhrase}. Details: $responseBody";
      }
    } catch (e) {
      print("Exception: ${e.toString()}");
      res = e.toString();
      rethrow;
    }

    return res;
  }




  Future<String> updateUserData(String firstName, String lastName, XFile? file,
      String mobile, String imgUrl) async {
    String res = "Somthing Went Wrong";

    try {
      // var response = await http.post(
      //     Uri.parse("${Constants.BASE_URL}/api/v1/user"),
      //     body: jsonEncode(user.toJson()),
      //     headers: {'Content-Type': "multipart/form-data"});
      // Create a multipart request for the server

      var uri = Uri.parse(
          "${Constants.BASE_URL}/api/v1/user/update-image"); // Replace with your Node.js server URL
      var request = http.MultipartRequest('PATCH', uri);
      print(imgUrl);
      request.fields['firstname'] = firstName;
      request.fields['lastname'] = lastName;
      request.fields['img'] = imgUrl;
      request.fields['mobile'] = mobile;
      if (file != null) {
        var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
        var length = await file.length();
        var multipartFile = http.MultipartFile('image', stream, length,
            filename: basename(file.path));

        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        res = "User has Been Updated";
      } else {
        res = "Failed to Register User ${response.reasonPhrase}";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<UserM.User> getUserByID(String id) async {
    UserM.User model = UserM.User();    try {
      var response = await http.get(Uri.parse(
          "${Constants.BASE_URL}${Constants.GET_USER_DATA_BYID}/$id"));
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        print(data);
        model = UserM.User.fromJson(data);
        return model;
      }
    } catch (e) {
      print(e.toString());
    }
    return model;
  }

  Future<List<UserM.User>> getSelectedUser(List<OrderModel> orders) async {
    List<UserM.User> users = [];
    print(orders[0]);

    for (int i = 0; i < orders.length; i++) {
      var user = await getUserByID(orders[i].userid.toString());

      users.add(user);
    }
    return users;
  }
}
