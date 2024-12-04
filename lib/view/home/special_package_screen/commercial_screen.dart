// commercial_packages_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/utils/auth_check/auth_check.dart';
import 'package:sehr_remake/view/home/special_package_screen/view_list_screen.dart';
import '../../../components/loading_widget.dart';
import '../../../components/special_package_item_component.dart';
import '../../../components/terms_and_conditions_dialog.dart';
import '../../../controller/special_package_controller.dart';
import '../../../controller/user_view_list_controller.dart';
import '../../../model/special_package_model.dart';
import '../../../utils/color_manager.dart';
import '../../collecting_user_data/customer_bio.dart';
import 'package:flutter/services.dart';

class CommercialPackagesScreen extends StatefulWidget {
  bool? isFromLogin = false;
  bool? isFromLogout = false;
  String? email;
  final String selectedLocationId;
   CommercialPackagesScreen({super.key, this.email,this.isFromLogin,required this.selectedLocationId,this.isFromLogout});


  @override
  State<CommercialPackagesScreen> createState() => _CommercialPackagesScreenState();
}

class _CommercialPackagesScreenState extends State<CommercialPackagesScreen> {
  final SpecialPackageController _controller = Get.put(SpecialPackageController());

  final UserTableController _tableController = Get.put(UserTableController());

  @override
  void initState() {
    super.initState();
    // Set the status bar color to black
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Set the status bar color to black
      statusBarIconBrightness: Brightness.light, // Set the status bar icons to light
    ));
    _controller.fetchCommercialPackages();
  }

  @override
  Widget build(BuildContext context) {
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
                'Commercial Packages',
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
                onPressed: () => Get.back(),
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
        child: Obx(() {
          if (_controller.commercialPackages.isEmpty) {
            return Center(child: loadingSpinkit(ColorManager.gradient1, 80));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: _controller.commercialPackages.map((SpecialPackageModel package) {
                  return SpecialPackageItem(
                    packageId: package.id,
                    title: package.title,
                    note: package.note,
                    description: package.description,
                    description2: package.description2,
                    activatePressed: () {
                      termsAndConditionsDialog(context,
                          onContinuePressed: () {
                        Get.back();
                            widget.isFromLogin == true ?
                            Get.to(
                                AuthCheck(
                                  specialPackageName: package.id,
                                  selectedLocationId: widget.selectedLocationId,
                                  isFromSpecialPackage: true,
                                )):
                            Get.to(
                                AddCustomerBioView(
                                  specialPackageName: package.id,
                                  selectedLocationId: widget.selectedLocationId,
                                  email: widget.email,
                                ));
                          }
                      );

                    },

                    viewListPressed: () {
                      Get.to(const ViewListScreen());
                    }, type: 'commercial',
                  );
                }).toList(),
              ),
            );
          }
        }),
      ),
    );
  }
}
