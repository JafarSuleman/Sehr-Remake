import 'package:flutter/material.dart';

import 'app/constant.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late Orientation orientation;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double viewInsectsBottom;
  // static late double defaultSize;

  void init(BuildContext context) async {
    _mediaQueryData = MediaQuery.of(context);
    orientation = _mediaQueryData.orientation;
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    viewInsectsBottom = _mediaQueryData.viewInsets.bottom;
  }
}

// Get the proportionate height as per screen size = ScreenUtils h,sp,r
double getProportionateScreenHeight(double inputHeight) {
  final double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / kDesignHeight) * screenHeight;
}

// Get the proportionate height as per screen size = ScreenUtils w
double getProportionateScreenWidth(double inputWidth) {
  final double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / kDesignWidth) * screenWidth;
}

SizedBox buildVerticleSpace(double height) {
  return SizedBox(
    height: getProportionateScreenHeight(height),
  );
}

SizedBox buildHorizontalSpace(double width) {
  return SizedBox(
    width: getProportionateScreenWidth(width),
  );
}
