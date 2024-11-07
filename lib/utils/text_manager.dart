import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'values_manager.dart';

class TextStyleManager {
  static TextStyle _getTextStyle(String fontFamily, Color textColor,
      double fontSize, FontWeight fontWeight,
      {double? letterSpacing}) {
    return TextStyle(
        fontFamily: fontFamily,
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing);
  }

  static TextStyle lightTextStyle({
    Color textColor = Colors.white,
    double fontSize = FontSize.s14,
  }) {
    return _getTextStyle(
      AppFontFamiy.bentonSans,
      textColor,
      fontSize,
      FontWeightManager.light,
    );
  }

  static TextStyle regularTextStyle({
    Color? color,
    double? fontSize,
    double? letterSpacing,
    double? lineHeight,
  }) {
    return GoogleFonts.libreFranklin(
      // AppFontFamiy.bentonSans,
      color: color ?? ColorManager.black,
      fontSize: fontSize ?? FontSize.s14,
      fontWeight: FontWeightManager.regular,
      letterSpacing: letterSpacing,
      height: lineHeight,
    );
  }

  static TextStyle mediumTextStyle({
    Color? color,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? textDecoration,
  }) {
    return GoogleFonts.libreFranklin(
      // AppFontFamiy.bentonSans,
      color: color ?? ColorManager.black,
      fontSize: fontSize ?? FontSize.s14,
      fontWeight: FontWeightManager.medium,
      letterSpacing: letterSpacing,
      decoration: textDecoration,
      height: height,
      // decorationStyle: TextDecorationStyle.solid,
    );
  }

  // static TextStyle semiBoldTextStyle({
  //   Color textColor = Colors.white,
  //   double fontSize = FontSize.s14,
  // }) {
  //   return _getTextStyle(
  //     AppFontFamiy.bentonSans,
  //     textColor,
  //     fontSize,
  //     FontWeightManager.semiBold,
  //   );
  // }

  static TextStyle boldTextStyle({
    Color? color,
    double? fontSize,
    double? letterSpacing,
  }) {
    return GoogleFonts.libreFranklin(
      // AppFontFamiy.bentonSans,
      color: color ?? ColorManager.black,
      fontSize: fontSize ?? FontSize.s14,
      fontWeight: FontWeightManager.bold,
      letterSpacing: letterSpacing,
    );
  }
}

class OutlineInputBorderStyle {
  static OutlineInputBorder _getOutlineInputBorder(
      {Color? color,
      double? width,
      BorderRadius borderRadius = const BorderRadius.all(
        Radius.circular(AppSize.s22),
      ),
      BorderSide? borderSide}) {
    return OutlineInputBorder(
      borderSide: borderSide ??
          BorderSide(
            color: color ?? Colors.grey,
            width: width ?? AppSize.s1_5,
          ),
      borderRadius: borderRadius,
    );
  }

  static OutlineInputBorder getEnabledBorder() {
    return _getOutlineInputBorder(
      borderSide: BorderSide.none,
    );
  }

  static OutlineInputBorder getFocusBorder() {
    return _getOutlineInputBorder(
      color: ColorManager.primary,
      // width: AppSize.s1_5,
      // borderRadius: BorderRadius.circular(AppSize.s8),
    );
  }

  static OutlineInputBorder getErrorBorder() {
    return _getOutlineInputBorder(
      color: ColorManager.error,
      // width: AppSize.s1_5,
      // borderRadius: BorderRadius.circular(AppSize.s8),
    );
  }

  static OutlineInputBorder getFocusedErrorBorder() {
    return _getOutlineInputBorder(
      color: ColorManager.primary,
      // width: AppSize.s1_5,
      // borderRadius: BorderRadius.circular(AppSize.s8),
    );
  }
}

class UnderLineInptBorderStyle {
  static UnderlineInputBorder _getUnderLineInputBorder({
    Color color = Colors.grey,
    double width = AppSize.s1_5,
  }) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  static UnderlineInputBorder getEnabledBorder() {
    return _getUnderLineInputBorder(
      color: ColorManager.grey,
    );
  }

  static UnderlineInputBorder getFocusBorder() {
    return _getUnderLineInputBorder(
      color: ColorManager.white,
    );
  }

  static UnderlineInputBorder getErrorBorder() {
    return _getUnderLineInputBorder(
      color: ColorManager.error,
    );
  }

  static UnderlineInputBorder getFocusedErrorBorder() {
    return _getUnderLineInputBorder(
      color: ColorManager.error,
    );
  }
}
