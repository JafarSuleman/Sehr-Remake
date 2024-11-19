// non_commercial_packages_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/view/home/special_package_screen/view_list_screen.dart';
import '../../../components/loading_widget.dart';
import '../../../components/special_package_item_component.dart';
import '../../../components/terms_and_conditions_dialog.dart';
import '../../../controller/special_package_controller.dart';
import '../../../controller/user_view_list_controller.dart';
import '../../../model/special_package_model.dart';
import '../../../utils/auth_check/auth_check.dart';
import '../../../utils/color_manager.dart';
import '../../collecting_user_data/customer_bio.dart';

class NonCommercialPackagesScreen extends StatefulWidget {
  bool? isFromLogin = false;
  bool? isFromLogout = false;
  String? email;
  final String selectedLocationId;
  NonCommercialPackagesScreen({super.key, this.email,this.isFromLogin, required this.selectedLocationId,this.isFromLogout});

  @override
  State<NonCommercialPackagesScreen> createState() => _NonCommercialPackagesScreenState();
}

class _NonCommercialPackagesScreenState extends State<NonCommercialPackagesScreen> {
  final SpecialPackageController _controller = Get.put(SpecialPackageController());

  final UserTableController _tableController = Get.put(UserTableController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.fetchNonCommercialPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Non Commercial Packages"),
        centerTitle: true,
        backgroundColor: ColorManager.home_button,
      ),
      body: Obx(() {
        if (_controller.nonCommercialPackages.isEmpty) {
          return  Center(child: loadingSpinkit(ColorManager.gradient1, 80));
        } else {
          return SingleChildScrollView(
            child: Column(
              children: _controller.nonCommercialPackages.map((SpecialPackageModel package) {
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
                  },                  viewListPressed: () {
                    Get.to(const ViewListScreen());
                  }, type: 'non-commercial',
                );
              }).toList(),
            ),
          );
        }
      }),
    );
  }
}
