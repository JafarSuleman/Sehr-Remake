import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/view/home/home.dart';
import '../../../components/app_button_widget.dart';
import '../../../utils/app/constant.dart';
import '../../../utils/asset_manager.dart';
import '../../../utils/color_manager.dart';
import '../../../utils/routes/routes.dart';
import '../../../utils/size_config.dart';

class OrderProcessingView extends StatelessWidget {
  const OrderProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // const TopBackButtonWidget(),
            const Spacer(flex: 2),
            Image.asset(
              AppImages.process,
              height: getProportionateScreenHeight(120),
            ),
            buildVerticleSpace(50),
            kTextBentonSansMed(
              'Processing',
              color: ColorManager.primary,
              fontSize: getProportionateScreenHeight(30),
            ),
            buildVerticleSpace(12),
            kTextBentonSansMed(
              'order placed successfully, check out the status of order',
              fontSize: getProportionateScreenHeight(20),
              textAlign: TextAlign.center,
            ),
            buildVerticleSpace(12),
            kTextBentonSansMed(
              'Your Order is in Process',
              fontSize: getProportionateScreenHeight(20),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(125),
              ),
              child: AppButtonWidget(
                bgColor: ColorManager.primary,
                ontap: () {
                  Navigator.pop(context);
                },
                text: 'Back',
              ),
            ),
            buildVerticleSpace(80),
          ],
        ),
      ),
    );
  }
}
