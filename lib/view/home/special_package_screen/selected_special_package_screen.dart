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
    await specialPackageController.loadSpecialPackages();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    SpecialPackageModel? activatedSpecialPackage;
    if (widget.specialPackageId != null) {
      activatedSpecialPackage = specialPackageController.commercialPackages.firstWhereOrNull(
            (pkg) => pkg.id == widget.specialPackageId,
      ) ?? specialPackageController.nonCommercialPackages.firstWhereOrNull(
            (pkg) => pkg.id == widget.specialPackageId,
      );
    }

    if (activatedSpecialPackage == null) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(
          child: Text(
            "No special package activated.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
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
        child: SizedBox(
          height: 290,
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
              "Selected Special Package",
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
    );
  }
}
