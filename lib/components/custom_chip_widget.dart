import 'package:flutter/material.dart';

import '../utils/app/constant.dart';
import '../utils/color_manager.dart';
import '../utils/size_config.dart';

class CustomChipWidget extends StatelessWidget {
  const CustomChipWidget({
    Key? key,
    this.text,
    this.child,
    this.height,
    this.width,
    this.borderRadius,
    this.bgColor,
    this.textColor,
    this.textSize,
  }) : super(key: key);
  final String? text;
  final Widget? child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? bgColor;
  final Color? textColor;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? getProportionateScreenHeight(34),
      width: width ?? getProportionateScreenWidth(76),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor ?? ColorManager.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          borderRadius ?? getProportionateScreenHeight(18.5),
        ),
      ),
      child: child ??
          kTextBentonSansMed(
            text ?? '',
            fontSize: textSize ?? getProportionateScreenHeight(12),
            color: textColor ?? ColorManager.primary,
          ),
    );
  }
}
