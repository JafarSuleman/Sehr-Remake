import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import '../../controller/user_controller.dart';

class EmailVerificationCodeView extends StatefulWidget {
  final String email;
  String? specialPackageName;
  String? selectedLocationId;


   EmailVerificationCodeView({Key? key, required this.email,this.specialPackageName,this.selectedLocationId}) : super(key: key);

  @override
  State<EmailVerificationCodeView> createState() => _EmailVerificationCodeViewState();
}

class _EmailVerificationCodeViewState extends State<EmailVerificationCodeView> 
    with SingleTickerProviderStateMixin {
  
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    print("Auth Screen Special Package ==> ${widget.specialPackageName}");

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
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
            Column(
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
                        'Verify Your Email',
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
                        widget.email,
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
                    controller: _otpController,
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(27),
                  ),
                  child: AppButtonWidget(
                    ontap: isLoading ? null : () async {
                      if (_otpController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter 6-digit code")));
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      bool otpVerified = await UserController()
                          .verifyEmailOTP(_otpController.text);
                      setState(() {
                        isLoading = false;
                      });
                      if (otpVerified) {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isEmailAuthenticated', true);
                        await prefs.setString('email', widget.email);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  AuthCheck(email: widget.email,specialPackageNameFromOtp: widget.specialPackageName,selectedLocationIdFromOtp: widget.selectedLocationId,),
                            ),
                              (route) => false,
                        );
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Invalid OTP")));
                      }
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
                buildVerticleSpace(30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
