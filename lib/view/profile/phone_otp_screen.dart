import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/app_button_widget.dart';
import '../../components/loading_widget.dart';
import '../../components/top_back_button_widget.dart';
import '../../utils/app/constant.dart';
import '../../utils/asset_manager.dart';
import '../../utils/auth_check/auth_check.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';
import '../../utils/text_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class phoneNumberVerificationCodeView extends StatefulWidget {
  final String phone;
  String? specialPackageName;
  String? selectedLocationId;
  bool? isWhatsApp;

  phoneNumberVerificationCodeView({
    super.key,
    required this.phone,
    this.specialPackageName,
    this.selectedLocationId,
    this.isWhatsApp,
  });

  @override
  State<phoneNumberVerificationCodeView> createState() =>
      _phoneNumberVerificationCodeViewState();
}

class _phoneNumberVerificationCodeViewState
    extends State<phoneNumberVerificationCodeView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _pincodeController = TextEditingController();
  String? _verificationId;
  bool isLoading = false;
  String? whatsAppNumber;

  void _verifyPhoneNumber() async {
    String phone = widget.phone.startsWith('0')
        ? widget.phone.replaceFirst('0', '+92')
        : widget.phone;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification Failed: ${e.code}');
        },
        codeSent: (String? verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> _verifyWhatsAppOTP(String otp) async {
    String? phone = widget.phone.startsWith('0')
        ? widget.phone.replaceFirst('0', '+92')
        : widget.phone;

    setState(() {
      whatsAppNumber = phone;
    });

    print("WhatsApp Number ===> $phone");

    try {
      final response = await http.post(
        Uri.parse('${Constants.BASE_URL}${Constants.VERIFY_WHATSAPP_OTP}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'whatsappNumber': phone,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          print("WhatsApp OTP verified successfully.");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isWhatsAppAuthenticated', true);
          await prefs.setString('whatsApp', phone);
          print("WhatsApp Number 2 ===> $phone");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => AuthCheck(
                whatsApp: whatsAppNumber,
                specialPackageNameFromOtp: widget.specialPackageName,
                selectedLocationIdFromOtp: widget.selectedLocationId,
              ),
            ),
                (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid WhatsApp OTP.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to verify WhatsApp OTP.")),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithOTP(String smsCode) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      if (user.uid.isNotEmpty) {
        print('User signed in: ${user.phoneNumber}');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AuthCheck(
              specialPackageNameFromOtp: widget.specialPackageName,
              selectedLocationIdFromOtp: widget.selectedLocationId,
            ),
          ),
              (route) => false,
        );
      } else {
        print('Error signing in');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'invalid-verification-code') {
        errorMessage = 'Incorrect OTP. Please try again.';
      } else if (e.code == 'session-expired') {
        errorMessage = 'OTP has expired. Please request a new one.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isWhatsApp == false) {
      _verifyPhoneNumber();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Image.asset(
              AppImages.pattern2,
              color: ColorManager.primary.withOpacity(0.1),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: const TopBackButtonWidget()),
                buildVerticleSpace(20),
                Padding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(27),
                  ),
                  child: kTextBentonSansMed(
                    'Enter 6-digit\nVerification code',
                    fontSize: getProportionateScreenHeight(25),
                  ),
                ),
                buildVerticleSpace(20),
                Padding(
                  padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(27)),
                  child: kTextBentonSansMed(
                    'Code sent to ${widget.phone}',
                    fontSize: getProportionateScreenHeight(12),
                  ),
                ),
                buildVerticleSpace(38),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(23),
                  ),
                  child: Container(
                    height: getProportionateScreenHeight(100),
                    width: SizeConfig.screenWidth,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30),
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(
                        getProportionateScreenHeight(22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black.withOpacity(0.05),
                          blurRadius: getProportionateScreenHeight(20),
                        ),
                      ],
                    ),
                    child: PinCodeFields(
                      length: 6,
                      controller: _pincodeController,
                      autoHideKeyboard: false,
                      keyboardType: TextInputType.number,
                      borderColor: ColorManager.black,
                      activeBorderColor: ColorManager.primary,
                      textStyle: TextStyleManager.regularTextStyle(
                        fontSize: getProportionateScreenHeight(40),
                      ),
                      onComplete: (result) {},
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(118),
                  ),
                  child: AppButtonWidget(
                    ontap: isLoading
                        ? null
                        : () async {
                      if (_pincodeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Enter 6-digit code")));
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });

                      if (widget.isWhatsApp!) {
                        await _verifyWhatsAppOTP(_pincodeController.text);
                      } else {
                        await _signInWithOTP(_pincodeController.text);
                      }

                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: isLoading
                        ? loadingSpinkit(ColorManager.home_button)
                        : Text('Verify',
                        style: TextStyle(color: ColorManager.white)),
                  ),
                ),
                buildVerticleSpace(50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
