import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/package_controller.dart';
import 'package:sehr_remake/view/home/special_package_screen/special_package_screen.dart';
import '../../components/loading_widget.dart';
import '../../components/special_Package_Info_Dialog.dart';
import '../../components/terms_and_conditions_dialog.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../components/package_item_component.dart';
import '../../components/home_button_component.dart';
import '../collecting_user_data/customer_bio.dart';

class PackageScreen extends StatefulWidget {
  final String? email;
  final String? whatsApp;
  bool? isFromLogout=false;
  PackageScreen({super.key,this.whatsApp, this.email,this.isFromLogout});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceAnimationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    print("Email from Packages screen ==> ${widget.email}");

    _bounceAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: 8.0,
    ).animate(
      CurvedAnimation(
        parent: _bounceAnimationController,
        curve: Curves.decelerate,
      ),
    );

    void performDoubleBounce() {
      if (!mounted) return;
      
      _bounceAnimationController.forward().then((_) {
        if (!mounted) return;
        _bounceAnimationController.reverse().then((_) {
          if (!mounted) return;
          Future.delayed(const Duration(milliseconds: 100), () {
            if (!mounted) return;
            _bounceAnimationController.forward().then((_) {
              if (!mounted) return;
              _bounceAnimationController.reverse();
            });
          });
        });
      });
    }

    performDoubleBounce();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      performDoubleBounce();
    });
  }

  @override
  void dispose() {
    _bounceAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var packageController = context.watch<PackageController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Set your AppBar height here
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20), // Round only the bottom corners
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
        child: Builder(
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
                      onTap: () {
                        specialPackageInfoDialog(context, null, false, widget.email, widget.isFromLogout);
                      },
                      child: AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_bounceAnimation.value),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                      "Special Package",
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
                          termsAndConditionsDialog(context,
                              onContinuePressed: () {
                                Get.back();
                                Get.to(AddCustomerBioView(
                                  whatsApp: widget.whatsApp,
                                  packageName: e.id,
                                  email: widget.email,
                                ));
                              }
                          );
                        },
                      ),
                    ).toList(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

}

