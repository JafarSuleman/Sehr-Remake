import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/package_controller.dart';
import 'package:sehr_remake/view/home/special_package_screen/special_package_screen.dart';
import '../../components/loading_widget.dart';
import '../../components/special_Package_Info_Dialog.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../components/package_item_component.dart';
import '../../components/home_button_component.dart';
import '../collecting_user_data/customer_bio.dart';

class PackageScreen extends StatefulWidget {
  final String? email;
  PackageScreen({super.key, this.email});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkAnimationController;
  bool showBlinking = true;

  @override
  void initState() {
    super.initState();

    print("Email ==> ${widget.email}");

    // Initialize the animation controller for blinking effect
    _blinkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var packageController = context.watch<PackageController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sehr Packages"),
        backgroundColor: ColorManager.gradient1,
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          print('isLoading: ${packageController.isLoading}');
          if (packageController.isLoading) {
            return Center(
              child: loadingSpinkit(ColorManager.home_button, 60),
            );
          } else if (packageController.packages.isEmpty) {
            return const Center(
              child: Text('No packages available.'),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  // Add the blinking button at the top
                  GestureDetector(
                    onTap:(){
                      specialPackageInfoDialog(context,);
                    },
                    child: AnimatedBuilder(
                      animation: _blinkAnimationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: showBlinking ? _blinkAnimationController.value : 1.0,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: HomeButtonComponent(
                              btnColor: Colors.redAccent,
                              width: double.infinity,
                              imagePath: AppIcons.specialIcon,
                              iconColor: Colors.white,
                              btnTextColor: Colors.white,
                              name: "Special Package",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // List of packages
                  ...packageController.packages.map(
                        (e) => PackageItem(
                      title: e.title,
                      description: e.description,
                      pressed: () {
                        Get.to(AddCustomerBioView(
                          packageName: e.id,
                          email: widget.email,
                        ));
                      },
                    ),
                  ).toList(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

}

