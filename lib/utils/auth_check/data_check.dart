import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/view/home/package_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/loading_widget.dart';
import '../../controller/user_controller.dart';
import '../../view/collecting_user_data/customer_bio.dart';
import '../../view/home/home.dart';
import '../color_manager.dart';

class CheckForData extends StatefulWidget {
  final String? email;
  String? specialPackageName;
  String? specialPackageNameFromOtp;
  String? selectedLocationIdFromOtp;


  CheckForData({super.key, this.email,this.specialPackageName,this.specialPackageNameFromOtp,this.selectedLocationIdFromOtp});

  @override
  State<CheckForData> createState() => _CheckForDataState();
}

class _CheckForDataState extends State<CheckForData> {
  final UserController _userController = UserController();  // Use a single instance of UserController

  @override
  Widget build(BuildContext context) {
    print("Email From CheckData ==> ${widget.email}");
    print("Check For Data Screen Special Package id ==> ${widget.specialPackageName}");
    print("Check For Data Screen Special Package Id From Otp ==> ${widget.specialPackageNameFromOtp}");
    Future<bool> checkUserData = _checkUserData();
    return FutureBuilder(
      future: checkUserData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return HomeScreen();
            } else if(widget.specialPackageNameFromOtp != null){
              return AddCustomerBioView(
                specialPackageName: widget.specialPackageNameFromOtp.toString(),
                selectedLocationId: widget.selectedLocationIdFromOtp.toString(),
                email: widget.email,
              );
            } else{
              return PackageScreen(email: widget.email);
            }
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text(snapshot.error.toString())),
            );
          }
        }
        return Scaffold(
          body: Center(child: loadingSpinkit(ColorManager.gradient1, 80)),
        );
      },
    );
  }

  Future<bool> _checkUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authMethod = prefs.getString('authMethod') ?? '';
    String identifier = prefs.getString('identifier') ?? '';

    print("Auth Method ==> $authMethod");
    print("Identifier ==> $identifier");

    if (authMethod.isEmpty || identifier.isEmpty) {
      return false;
    }

    // Check if user exists and fetch user data
    bool userExists = await _userController.checkIfUserExists(identifier);
    print("User Exists ===> $userExists");
    if (!userExists) return false;

    // Fetch the user data to check the package and special package activation
    await _userController.getUserData(identifier, context);
    print("Activated Package ==> ${_userController.userModel.package}");
    print("Activated Special Package ==> ${_userController.userModel.specialPackage}");

    // Check if either package or specialPackage is activated
    return (_userController.userModel.package != null && _userController.userModel.package!.isNotEmpty) ||
        (_userController.userModel.specialPackage != null && _userController.userModel.specialPackage!.isNotEmpty);
  }
}
