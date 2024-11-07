import 'package:flutter/material.dart';

class ColorManager {
  static Color home_button = HexColor.fromHex("#B6FACB");
  static Color transparent = Colors.transparent;
  static Color primary = HexColor.fromHex('#15BE77');
  static Color primaryLight = HexColor.fromHex('#53E88B');
  static Color secondary = HexColor.fromHex('#DA6317');
  static Color secondaryLight = HexColor.fromHex('#F9A84D');
  static Color ambar = HexColor.fromHex('#FEAD1D');
  static Color blue = Colors.blue;
  static Color lightBlue = HexColor.fromHex('#5A6CEAFC');
  static Color white = HexColor.fromHex('#FFFFFF');
  static Color black = HexColor.fromHex('#09051C');
  static Color grey = HexColor.fromHex('#D9D9D9');
  static Color lightGrey = HexColor.fromHex('#F6F6F6');
  static Color textGrey = HexColor.fromHex('#3B3B3B');
  static Color lightBlue2 = HexColor.fromHex('#7898f9');
  static Color error = HexColor.fromHex('#e61f34'); // red color
  static Color errorLight = Colors.redAccent; // red color
  // Icons Color
  static Color icon = HexColor.fromHex('#DA6317');
  // Gradient Colors
  static Color gradient1 = HexColor.fromHex('#53E88B');
  static Color gradient2 = HexColor.fromHex('#15BE77');
  static Color elevationColor = const Color.fromRGBO(90, 108, 234, 0.07);

  //
  // static Color darkGrey = HexColor.fromHex('#D9D9D9');
  // static Color accent = HexColor.fromHex('#06C3FF');
  // static Color yellow = HexColor.fromHex('#FAFF00');
  // static const Color white = Colors.white;
  //
  // static Color darkPrimary = HexColor.fromHex('#d17d11');
  // static Color primaryOpacity70 = HexColor.fromHex('#B3ED9728');
  // static Color grey1 = HexColor.fromHex('#AAAAAA');
  // static Color grey2 = HexColor.fromHex('#797979');
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF$hexColorString'; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
