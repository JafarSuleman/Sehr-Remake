import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../controller/special_package_controller.dart';
import '../../../controller/user_view_list_controller.dart';
import '../../../model/special_package_model.dart';
import '../../../utils/color_manager.dart';
import '../../../components/special_package_item_component.dart';
import '../../../controller/user_controller.dart';
import 'view_list_screen.dart';

class SelectedSpecialPackageScreen extends StatefulWidget {
  final String? specialPackageId;
  SelectedSpecialPackageScreen({Key? key, this.specialPackageId}) : super(key: key);

  @override
  State<SelectedSpecialPackageScreen> createState() => _SelectedSpecialPackageScreenState();
}

class _SelectedSpecialPackageScreenState extends State<SelectedSpecialPackageScreen> {
  final UserTableController userTableController = Get.put(UserTableController());
  final SpecialPackageController specialPackageController = Get.find<SpecialPackageController>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    // Load packages if not already loaded
    await specialPackageController.loadSpecialPackages();
    setState(() {
      isLoading = false; // Set loading to false after packages are loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Display loading indicator while fetching packages
      return Scaffold(
        appBar: AppBar(
          title: const Text("Selected Special Package"),
          backgroundColor: ColorManager.home_button,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Attempt to find the activated special package
    SpecialPackageModel? activatedSpecialPackage;
    if (widget.specialPackageId != null) {
      print("Looking for package ID: ${widget.specialPackageId}");

      // Check for matching package in both lists
      activatedSpecialPackage = specialPackageController.commercialPackages.firstWhereOrNull(
            (pkg) => pkg.id == widget.specialPackageId,
      ) ??
          specialPackageController.nonCommercialPackages.firstWhereOrNull(
                (pkg) => pkg.id == widget.specialPackageId,
          );
    }

    if (activatedSpecialPackage == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Selected Special Package"),
          backgroundColor: ColorManager.home_button,
        ),
        body: const Center(
          child: Text(
            "No special package activated.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selected Special Package"),
        backgroundColor: ColorManager.home_button,
      ),
      body: SizedBox(
        height: 270,
        child: SpecialPackageItem(
          packageId: activatedSpecialPackage.id,
          title: activatedSpecialPackage.title,
          description: activatedSpecialPackage.description,
          note: activatedSpecialPackage.note,
          description2: activatedSpecialPackage.description2,
          viewListPressed: () {
            userTableController.fetchUsersBySpecialPackage(
                activatedSpecialPackage!.id, activatedSpecialPackage.type);
            Get.to(const ViewListScreen());
          },
          activatePressed: () {},
          type: activatedSpecialPackage.type,
          activateButtonText: "Activated",
        ),
      ),
    );
  }
}
