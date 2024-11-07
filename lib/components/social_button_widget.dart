import 'package:flutter/material.dart';

import '../utils/app/constant.dart';
import '../utils/color_manager.dart';
import '../utils/size_config.dart';

class SocialButtonWidget extends StatelessWidget {
  const SocialButtonWidget({
    Key? key,
    this.onTap,
    required this.text,
    required this.icon,
  }) : super(key: key);
  final VoidCallback? onTap;
  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: getProportionateScreenHeight(57),
        width: getProportionateScreenWidth(152),
        padding: EdgeInsets.only(
          left: getProportionateScreenWidth(22),
          right: getProportionateScreenWidth(23),
        ),
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(
              getProportionateScreenHeight(15),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withOpacity(0.1),
                blurRadius: getProportionateScreenHeight(15),
              ),
            ]),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: getProportionateScreenHeight(25),
              width: getProportionateScreenHeight(25),
            ),
            const Spacer(),
            kTextBentonSansMed(
              text,
              fontSize: getProportionateScreenHeight(14),
              lineSpacing: getProportionateScreenHeight(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
