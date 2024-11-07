import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/package_controller.dart';

import '../../components/logo_component.dart';
import '../../utils/asset_manager.dart';
import '../../utils/auth_check/auth_check.dart';
import '../../utils/routes/routes.dart';
import '../../utils/size_config.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // ignore: unused_field
  late Timer _timer;

  // void _splashScreenDelay() {
  //   _timer = Timer(const Duration(seconds: 3), _goNext);
  // }

  // void _goNext() {
  //   Get.to(() => const BusinessVerificationView());
  // }

  @override
  void initState() {
    context.read<PackageController>().getAllPackages();
    // _splashScreenDelay();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthCheck(),
          ));
    });
    super.initState();
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Stack(
            children: [
              Image.asset(AppImages.splashLogo),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: getProportionateScreenHeight(80),
                  ),
                  child: Image.asset(AppImages.ellipse1),
                ),
              ),
            ],
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
