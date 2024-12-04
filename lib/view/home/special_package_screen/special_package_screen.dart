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
    print('Selected Location ID: ${widget.selectedLocationId}');

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
                'Special Packages',
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
        child: Center(
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
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
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade900.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const SpecialPackageButtonComponent(
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
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
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade900.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const SpecialPackageButtonComponent(
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
      ),
    );
  }
}
