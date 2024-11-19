import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/utils/color_manager.dart';
import '../utils/string_manager.dart';

void termsAndConditionsDialog(
    BuildContext context,
    {
      String? specialPackage,
      bool? isFromLogin = false,
      String? email,
      bool? isFromLogout = false,
      required VoidCallback onContinuePressed
    }) {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            "Terms And Conditions",
            style: TextStyle(
              fontSize: 22,
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
              height: 460,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      StringManager.termsAndConditions,
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
                      backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => ColorManager.errorLight),
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
                      backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => ColorManager.home_button),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: onContinuePressed,
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
