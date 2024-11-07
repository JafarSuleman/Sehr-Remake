// special_package_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/location_model.dart';
import '../model/special_package_model.dart';
import '../utils/color_manager.dart';
import '../utils/string_manager.dart';

class SpecialPackageController extends GetxController {
  var commercialPackages = <SpecialPackageModel>[].obs;
  var nonCommercialPackages = <SpecialPackageModel>[].obs;
  var locations = <LocationModel>[].obs; // Add this line

  var activatedPackageId = ''.obs;
  var loadingPackageId = ''.obs;

  // Fetch commercial packages from the API
  Future<void> fetchCommercialPackages() async {
    try {
      var response = await http.get(
        Uri.parse('https://sehr-backend.onrender.com/api/v1/specialpackage/get-package?type=commercial'),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> packageList = data['data'];
        commercialPackages.value =
            packageList.map((e) => SpecialPackageModel.fromJson(e)).toList();
      } else {
        print('Failed to load commercial packages');
      }
    } catch (e) {
      print('Error fetching commercial packages: $e');
    }
  }

  // Fetch non-commercial packages from the API
  Future<void> fetchNonCommercialPackages() async {
    try {
      var response = await http.get(
        Uri.parse('https://sehr-backend.onrender.com/api/v1/specialpackage/get-package?type=non-commercial'),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> packageList = data['data'];
        nonCommercialPackages.value =
            packageList.map((e) => SpecialPackageModel.fromJson(e)).toList();
      } else {
        print('Failed to load non-commercial packages');
      }
    } catch (e) {
      print('Error fetching non-commercial packages: $e');
    }
  }

  // Method to fetch locations
  Future<void> fetchLocations() async {
    try {
      var response = await http.get(
          Uri.parse('https://sehr-backend.onrender.com/api/v1/location/get-locations'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> locationList = data['data'];
        locations.value =
            locationList.map((e) => LocationModel.fromJson(e)).toList();
      } else {
        print('Failed to load locations');
      }
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  // Method to show location selection dialog
  void showLocationSelectionDialog(
      BuildContext context, Function(String) onLocationSelected) async {
    String? selectedLocationId;
    Map<String, bool> selectedLocations = {};
    if (locations.isEmpty) {
      await fetchLocations();
    }

    if (locations.isNotEmpty) {
      for (var location in locations) {
        selectedLocations[location.id] = false;
      }

      Get.dialog(
        StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Center(child: Text('Select Location')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: locations.map((location) {
                    return ListTile(
                      leading: Checkbox(
                        value: selectedLocations[location.id],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedLocations.updateAll((key, value) => false);
                            selectedLocations[location.id] = value ?? false;
                            selectedLocationId = value == true ? location.id : null;
                          });
                        },
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          location.title,
                          style: const TextStyle(height: 1.2),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => ColorManager.errorLight,
                          ),
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
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => ColorManager.home_button,
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (selectedLocationId == null) {
                            Get.snackbar('Error', 'Please select location');
                          } else {
                            Get.back();
                            onLocationSelected(selectedLocationId!);
                          }
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    } else {
      // Handle error
      Get.snackbar('Error', 'Failed to fetch locations');
    }
  }



  // Method to activate a package
  void activatePackage(String packageId) async {
    if (activatedPackageId.value.isNotEmpty && activatedPackageId.value != packageId) {
      // Another package is already activated
      return;
    }
    loadingPackageId.value = packageId;
    // Simulate a delay or API call
    await Future.delayed(const Duration(seconds: 2));
    // After successful activation
    activatedPackageId.value = packageId;
    loadingPackageId.value = '';
  }

  void showInfoDialog(BuildContext context, String title, String description, String note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              title,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'UrduFont',
              ),
            ),
          ),
          content: SizedBox(
            width: 230,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    StringManager.specialPackageHouseDescription,
                    style: TextStyle(fontFamily: 'UrduFont', fontSize: 24),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 24, fontFamily: 'UrduFont'),
                  ),
                  const SizedBox(height: 15),
                  note != ""
                      ? Text(
                    " نوٹ\u2009:\u2009$note ",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'UrduFont',
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.redAccent
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'بند کریں', // 'Close' in Urdu
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 24, fontFamily: 'UrduFont', color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
