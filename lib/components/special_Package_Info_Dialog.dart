import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/utils/color_manager.dart';
import '../controller/special_package_controller.dart'; // Import the controller
import '../controller/user_controller.dart';
import '../utils/string_manager.dart';
import '../view/home/special_package_screen/location_selection_screen.dart';
import '../view/home/special_package_screen/special_package_screen.dart';

void specialPackageInfoDialog(BuildContext context, [String? specialPackage, bool? isFromLogin = false, String? email, bool? isFromLogout = false,]) {
  final UserController userController = Get.put(UserController());

  showDialog(
    context: context,
    barrierColor: Colors.black54,  // Darker overlay
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 680),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade900,
                      Colors.green.shade500,
                      Colors.green.shade900,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    StringManager.specialPackageDialogTitle,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'UrduFont',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              // Content
              Flexible(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const SingleChildScrollView(
                    child: Text(
                      StringManager.specialPackageDialogDescription,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'UrduFont',
                        fontSize: 20,
                        height: 1.8,
                        color: Colors.black87,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.red),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => Get.back(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                          print("Activated Special package ==> $specialPackage");
                          Get.back();
                          if (specialPackage != null) {
                            Get.to(() => SpecialPackageScreen(
                              selectedLocationId: userController.userModel.selectedLocationId ?? '',
                            ));
                          } else {
                            Get.back();
                            Get.to(() => LocationSelectionScreen(
                              isFromLogin: isFromLogin,
                              email: email,
                              isFromLogout: isFromLogout,
                            ));
                          }
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
