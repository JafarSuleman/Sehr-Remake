// special_package_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/special_package_button_component.dart';
import '../../../utils/asset_manager.dart';
import '../../../utils/color_manager.dart';
import '../../../utils/values_manager.dart';
import 'commercial_screen.dart';
import 'non_commercial_screen.dart';

class SpecialPackageScreen extends StatefulWidget {
  final bool? isFromLogin;
  bool? isFromLogout = false;
  final String? email;
  final String selectedLocationId;

   SpecialPackageScreen({super.key, this.email, this.isFromLogin, required this.selectedLocationId,this.isFromLogout});

  @override
  State<SpecialPackageScreen> createState() => _SpecialPackageScreenState();
}

class _SpecialPackageScreenState extends State<SpecialPackageScreen> {
  @override
  Widget build(BuildContext context) {
    // You can now use widget.selectedLocationId
    print('Selected Location ID: ${widget.selectedLocationId}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Special Packages'),
        centerTitle: true,
        backgroundColor: ColorManager.home_button,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => CommercialPackagesScreen(
                    email: widget.email,
                    isFromLogin: widget.isFromLogin,
                    isFromLogout: widget.isFromLogout,
                    selectedLocationId: widget.selectedLocationId,
                  ));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
                  child: SpecialPackageButtonComponent(
                    width: double.infinity,
                    imagePath: AppIcons.commercialIcon,
                    height: 120,
                    text: "کمرشل",
                    text2: '(بزنس مین۔انڈسٹریلسٹ)',
                  ),
                ),
              ),
              const SizedBox(height: AppMargin.m17),
              GestureDetector(
                onTap: () {
                  Get.to(() => NonCommercialPackagesScreen(
                    email: widget.email,
                    isFromLogin: widget.isFromLogin,
                    isFromLogout: widget.isFromLogout,
                    selectedLocationId: widget.selectedLocationId,
                  ));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
                  child: SpecialPackageButtonComponent(
                    width: double.infinity,
                    imagePath: AppIcons.nonCommercialIcon,
                    height: 120,
                    text: "نان کمرشل",
                    text2: '( ملازمت پیشہ۔ بے روزگار۔اورسیز)',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
