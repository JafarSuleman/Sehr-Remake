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
    extends State<phoneNumberVerificationCodeView> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _pincodeController = TextEditingController();
  String? _verificationId;
  bool isLoading = false;
  String? whatsAppNumber;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.isWhatsApp == false) {
      _verifyPhoneNumber();
    }
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isWhatsAppAuthenticated', true);
          await prefs.setString('whatsApp', phone);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xffeaeffae).withOpacity(0.5),
              Colors.white,
              Colors.white.withOpacity(0.5),
              const Color(0xffeaeffae),
            ],
          ),
        ),
        child: Stack(
          children: [
            Image.asset(
              AppImages.pattern2,
              color: ColorManager.primary.withOpacity(0.1),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopBackButtonWidget(),
                  buildVerticleSpace(50),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(27),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isWhatsApp == true
                              ? 'Verify Your WhatsApp'
                              : 'Verify Your Phone',
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(28),
                            fontWeight: FontWeight.bold,
                            color: ColorManager.black,
                          ),
                        ),
                        buildVerticleSpace(8),
                        Text(
                          'Please enter the 6-digit code sent to',
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(16),
                            color: ColorManager.black.withOpacity(0.6),
                          ),
                        ),
                        Text(
                          widget.phone,
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(16),
                            fontWeight: FontWeight.w600,
                            color: ColorManager.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildVerticleSpace(100),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(27),
                    ),
                    child: PinCodeFields(
                      length: 6,
                      controller: _pincodeController,
                      autoHideKeyboard: false,
                      keyboardType: TextInputType.number,
                      fieldWidth: getProportionateScreenWidth(45),
                      fieldHeight: getProportionateScreenHeight(65),
                      borderWidth: 1.5,
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(4),
                      ),
                      borderColor: ColorManager.black.withOpacity(0.2),
                      activeBorderColor: ColorManager.primary,
                      fieldBackgroundColor: ColorManager.white,
                      activeBackgroundColor: ColorManager.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      textStyle: TextStyle(
                        fontSize: getProportionateScreenHeight(20),
                        fontWeight: FontWeight.bold,
                      ),
                      animation: Animations.fade,
                      animationDuration: const Duration(milliseconds: 300),
                      animationCurve: Curves.easeInOut,
                      switchInAnimationCurve: Curves.easeIn,
                      switchOutAnimationCurve: Curves.easeOut,
                      fieldBorderStyle: FieldBorderStyle.square,
                      onChange: (value) {
                        if (value.length == 1) {
                          _animationController.forward().then((_) {
                            _animationController.reverse();
                          });
                        }
                      },
                      onComplete: (result) {
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                      },
                    ),
                  ),
                  buildVerticleSpace(80),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(27),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade900,
                            Colors.green.shade500,
                            Colors.green.shade900,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      child: AppButtonWidget(
                        ontap: isLoading ? null : () async {
                          if (_pincodeController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Enter 6-digit code")),
                            );
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
                        height: getProportionateScreenHeight(55),
                        width: double.infinity,
                        borderRadius: getProportionateScreenHeight(15),
                        child: isLoading
                            ? loadingSpinkit(ColorManager.white)
                            : Text(
                                'Verify',
                                style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: getProportionateScreenHeight(16),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                  buildVerticleSpace(30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
