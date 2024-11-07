import 'package:flutter/material.dart';

import '../utils/app/constant.dart';
import '../utils/color_manager.dart';
import '../utils/size_config.dart';

class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget({
    Key? key,
    required this.ontap,
    this.child,
    this.text = '',
    this.textSize,
    this.textColor,
    this.letterSpacing,
    this.bgColor,
    this.height,
    this.width,
    this.borderRadius,
    this.border = false,
  }) : super(key: key);
  final VoidCallback? ontap;
  final Widget? child;
  final String? text;
  final double? textSize;
  final Color? textColor;
  final double? letterSpacing;
  final Color? bgColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool? border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        borderRadius ?? getProportionateScreenHeight(15),
      ),
      onTap: ontap,
      child: Container(
        height: height ?? getProportionateScreenHeight(57),
        width: width ?? double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          gradient: bgColor == null
              ? LinearGradient(colors: [
                  ColorManager.gradient1,
                  // ColorManager.gradient1,
                  ColorManager.gradient2,
                ])
              : null,
          border: border == true
              ? Border.all(
                  color: ColorManager.grey,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(
            borderRadius ?? getProportionateScreenHeight(15),
          ),
        ),
        child: child ??
            kTextBentonSansMed(
              text??"",
              color: textColor ?? ColorManager.white,
              fontSize: textSize,
              lineSpacing: letterSpacing,
            ),
      ),
    );
  }
}
