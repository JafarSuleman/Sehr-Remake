import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app/constant.dart';
import '../utils/color_manager.dart';
import '../utils/size_config.dart';

class TopBackButtonWidget extends StatelessWidget {
  const TopBackButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: getProportionateScreenHeight(35),
          left: getProportionateScreenWidth(25),
        ),
        child: InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(
            getProportionateScreenHeight(15),
          ),
          child: Container(
            height: getProportionateScreenHeight(45),
            width: getProportionateScreenHeight(45),
            decoration: BoxDecoration(
              color: ColorManager.secondaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                getProportionateScreenHeight(15),
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorManager.icon,
              size: getProportionateScreenHeight(22),
            ),
          ),
        ),
      ),
    );
  }
}
