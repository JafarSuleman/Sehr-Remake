import 'package:flutter/material.dart';
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

class _EmailVerificationCodeViewState extends State<EmailVerificationCodeView> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;



  @override
  Widget build(BuildContext context) {
    print("Auth Screen Special Package ==> ${widget.specialPackageName}");

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
                const TopBackButtonWidget(),
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
                  padding: EdgeInsets.only(left: getProportionateScreenWidth(27)),
                  child: kTextBentonSansMed(
                    'Code sent to ${widget.email}',
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
                      controller: _otpController,
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
                    child: isLoading
                        ? loadingSpinkit(ColorManager.home_button)
                        :  Text('Next',style: TextStyle(color:ColorManager.white ),),
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
