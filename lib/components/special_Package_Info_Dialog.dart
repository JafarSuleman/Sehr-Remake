import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/utils/color_manager.dart';
import '../controller/special_package_controller.dart'; // Import the controller
import '../controller/user_controller.dart';
import '../utils/string_manager.dart';
import '../view/home/special_package_screen/special_package_screen.dart';

void specialPackageInfoDialog(BuildContext context, [String? specialPackage, bool? isFromLogin = false]  ) {
  final SpecialPackageController controller = Get.put(SpecialPackageController());
  final UserController userController = Get.put(UserController());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            StringManager.specialPackageDialogTitle,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'UrduFont',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const SizedBox(
              width: 350,
              height: 480,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      StringManager.specialPackageDialogDescription,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'UrduFont',
                        fontSize: 20,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.resolveWith((states) => ColorManager.errorLight),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.resolveWith((states) => ColorManager.home_button),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      print("Activated Special package ==> $specialPackage");
                      Get.back();
                      if (specialPackage != null) {
                        Get.to(() => SpecialPackageScreen(
                          selectedLocationId: userController.userModel.selectedLocationId ?? '',
                        ));
                      } else {
                        controller.showLocationSelectionDialog(context, (selectedLocationId) {
                          Get.to(() => SpecialPackageScreen(
                            isFromLogin: isFromLogin,
                            selectedLocationId: selectedLocationId,
                          ));
                        });
                      }
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
