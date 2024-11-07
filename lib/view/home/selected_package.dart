import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/package_controller.dart';
import 'package:sehr_remake/controller/user_controller.dart';
import 'package:sehr_remake/view/home/special_package_screen/special_package_screen.dart';
import '../../components/custom_chip_widget.dart';
import '../../components/home_button_component.dart';
import '../../model/package_model.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/text_manager.dart';

import '../../components/package_item_component.dart';
import '../../utils/color_manager.dart';

class SelectedPackageScreen extends StatefulWidget {
  const SelectedPackageScreen({super.key});

  @override
  State<SelectedPackageScreen> createState() => _SelectedPackageScreenState();
}

class _SelectedPackageScreenState extends State<SelectedPackageScreen> {
  @override
  Widget build(BuildContext context) {
    var packages = context.watch<PackageController>().packages;
    //var specialPackages = context.watch<PackageController>().specialPackages; // Make sure to have this
    var userData = context.watch<UserController>().userModel;

    var otherPackages = packages.where((element) => element.id != userData.package).toList();

    PackageModel? activatedPackage;
    final dummyPackage = PackageModel(id: '', title: '', description: ''); // Customize based on your PackageModel constructor

    if (userData.package != null) {
      // Regular package
      activatedPackage = packages.firstWhere(
            (element) => element.id == userData.package,
        orElse: () => dummyPackage,
      );
    } else if (userData.specialPackage != null) {
      // Special package
      activatedPackage = packages.firstWhere(
            (element) => element.id == userData.specialPackage,
        orElse: () => dummyPackage,
      );
    }

// Set activatedPackage to null if it matches dummyPackage
    if (activatedPackage == dummyPackage) {
      activatedPackage = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sehr Packages"),
        backgroundColor: ColorManager.gradient1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16.0),

              if (userData.specialPackage != null)
                GestureDetector(
                  onTap: (){
                    Get.to(SpecialPackageScreen(selectedLocationId: userData.selectedLocationId??""));
                  },
                  child: const HomeButtonComponent(
                    btnColor: Colors.redAccent,
                    width: double.infinity,
                    iconColor: Colors.white,
                    btnTextColor: Colors.white,
                    name: "Special Package Activated",
                  ),
                ),
              if (activatedPackage != null)
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          activatedPackage.title.toString(),
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'UrduFont',
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          activatedPackage.description.toString(),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontFamily: 'UrduFont',fontSize: 18),
                        ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 50),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith(
                                    (states) => ColorManager.home_button // Original color for activated package,
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                              ),
                            ),
                            onPressed: () {  },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: Colors.black, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  'Activated',
                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                ),
                              ],
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const Divider(color: Colors.grey),
              Text(
                "Other Packages",
                style: TextStyleManager.mediumTextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: otherPackages.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              e.title.toString(),
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'UrduFont',
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              e.description.toString(),
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontFamily: 'UrduFont',fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
