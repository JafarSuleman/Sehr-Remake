import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/package_controller.dart';
import 'package:sehr_remake/controller/user_controller.dart';
import 'package:sehr_remake/view/home/special_package_screen/selected_special_package_screen.dart';
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
  String? selectedSpecialId;
  SelectedPackageScreen({super.key,this.selectedSpecialId});

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade900,
                  Colors.green.shade500,
                  Colors.green.shade900,
                ],
              ),
            ),
            child: AppBar(
              title: const Text(
                "Sehr Packages",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              elevation: 4,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xffeaeffae).withOpacity(0.5),
              Colors.white,
              Colors.white.withOpacity(0.5),
              const Color(0xffeaeffae),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                if (userData.specialPackage != null)
                  GestureDetector(
                    onTap: (){
                      if (userData.specialPackage != null &&
                          userData.specialPackage!.isNotEmpty) {
                        Get.to(() => SelectedSpecialPackageScreen(specialPackageId: widget.selectedSpecialId,));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.red.shade600,
                              Colors.red.shade800,
                              Colors.red.shade900,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppIcons.specialIcon,
                              color: Colors.white,
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Special Package Activated",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                if (activatedPackage != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Center(
                            child: Text(
                              activatedPackage.title.toString(),
                              style: const TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'UrduFont',
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          Text(
                            activatedPackage.description.toString(),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'UrduFont',
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.green.shade900,
                                    Colors.green.shade500,
                                    Colors.green.shade900,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.shade900.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white, size: 22),
                                    SizedBox(width: 12),
                                    Text(
                                      'Activated',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const Divider(color: Colors.grey),
                const Text(
                  "Other Packages",
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: otherPackages.map((e) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Center(
                              child: Text(
                                e.title.toString(),
                                style: const TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'UrduFont',
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Text(
                              e.description.toString(),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontFamily: 'UrduFont',
                                fontSize: 22,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
