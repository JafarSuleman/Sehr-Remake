import 'package:flutter/material.dart';

import '../size_config.dart';

import '../text_manager.dart';

class Constants {
  //static const BASE_URL = 'http://192.168.0.103:3505';
  static const BASE_URL = 'http://52.64.170.201:3505';
  static const CHECK_PROFILE_EXISTS = '/api/v1/user/check';
  static const CHECK_PROFILE_EXISTS_BY_EMAIL = '/api/v1/user/check-email';
  static const FIND_USER_PROFILE_BY_EMAIL = '/api/v1/user/send-otp';
  static const FIND_USER_PROFILE = '/api/v1/user/find';
  static const CREATE_USER_DATA = '/api/v1/user';
  static const GET_BUSSINESS = '/api/v1/business';

  static const SEND_OTP_EMAIL = '/api/v1/user/send-otp-email';
  static const VERIFY_OTP_EMAIL = '/api/v1/user/verify-otp-email';

  static const SEND_WHATSAPP_OTP = '/api/v1/user/send-whatsapp-otp';
  static const VERIFY_WHATSAPP_OTP = '/api/v1/user/verify-whatsapp-otp';

  static const FETCH_USER_BY_SPECIAL_ID = '/api/v1/specialpackage/users-by-special-package';


  static const PLACE_ORDER = '/api/v1/order';
  static const GET_SHOP_ORDERS = '/api/v1/order/shop';
  static const GET_USER_ORDERS = '/api/v1/order/user';

  static const GET_PACKAGES = '/api/v1/package';
  static const UPDATE_ORDER_STATUS = '/api/v1/order/update-status';
  static const GET_BUSSINESS_BYPHONE = "/api/v1/business/shop-data";

  static const GET_USER_DATA_BYID = '/api/v1/user';
  static const GET_CATEGORIES = '/api/v1/category';
  static const GET_SPECIAL_PACKAGES = '/api/v1/specialpackage/get-package';
  static const GET_LOCATIONS = '/api/v1/location/get-locations';
  static const CREATE_USER = '/api/v1/user/register';

  static const GET_COMMISIONSALE_DETAIL = '/api/v1/commission';
}

const double kDesignHeight = 852.0;
const double kDesignWidth = 393.0;

const kEmpty = "";
const kZero = 0;

enum UserRole { customer, business, non }

enum PaymentType { easyPaisa, visa, jazzCash }

enum Gender { male, female }

const SEHR_SHOP_ICON = 'assets/images/sehr-shop.jpg';

enum Status {
  // notLoggedIn,
  // notRegistered,
  // loggedIn,
  // registered,
  // authenticating,
  // registering,
  // loggedOut,
  loading,
  completed,
  error,
}

//color codes for sehr
// light green:  #B6FACB
// green: #5FBE7C
// dark gray: #122D40
Text kTextBentonSansReg(
  String text, {
  TextAlign? textAlign,
  double? fontSize,
  Color? color,
  double? letterSpacing,
  double? lineHeight,
  int? maxLines,
  TextOverflow? textOverFlow,
}) {
  return Text(
    text,
    style: TextStyleManager.regularTextStyle(
      fontSize: fontSize ?? getProportionateScreenHeight(14),
      color: color,
      letterSpacing: letterSpacing ?? getProportionateScreenHeight(0.5),
      lineHeight: lineHeight,
    ),
    textAlign: textAlign,
    overflow: textOverFlow,
    maxLines: maxLines,
  );
}

Text kTextBentonSansMed(
  String text, {
  TextAlign? textAlign,
  Color? color,
  double? fontSize,
  double? lineSpacing,
  double? height,
  TextOverflow? overFlow,
  int? maxLines,
  TextDecoration? textDecoration,
}) {
  return Text(
    text,
    style: TextStyleManager.mediumTextStyle(
      fontSize: fontSize ?? getProportionateScreenHeight(14),
      color: color,
      letterSpacing: lineSpacing,
      height: height,
      textDecoration: textDecoration,
    ),
    textAlign: textAlign,
    overflow: overFlow,
    maxLines: maxLines,
  );
}

Text kTextBentonSansBold(
  String text, {
  TextAlign? textAlign,
  double? fontSize,
  Color? color,
}) {
  return Text(
    text,
    style: TextStyleManager.boldTextStyle(
      fontSize: fontSize ?? getProportionateScreenHeight(14),
      color: color,
    ),
    textAlign: textAlign,
  );
}
