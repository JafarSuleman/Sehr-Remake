import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/app_button_widget.dart';
import '../../components/logo_component.dart';
import '../../components/text_field_component.dart';
import '../../utils/app/constant.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    //  final viewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(34),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildVerticleSpace(80),
                // const Spacer(),
                Column(
                  children: [
                    const LogoWidget(),
                    buildVerticleSpace(30),
                  ],
                ),
                kTextBentonSansBold(
                  'Sign Up',
                  fontSize: getProportionateScreenHeight(20),
                ),
                buildVerticleSpace(20),
                Form(
                  //  key: viewModel.signUpFormKey,
                  child: Column(
                    children: [
                      TextFieldWidget(
                        keyboardType: TextInputType.number,
                        hintText: 'Mobile',
                        prefixIcon: Icon(
                          Icons.phone_android_rounded,
                          size: getProportionateScreenHeight(18),
                          color: ColorManager.primaryLight,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile No is required';
                          } else if (value.length < 11) {
                            return 'Invalid mobile number';
                          }
                          return null;
                        },
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Mobile No is required';
                        //   }
                        //   if (!RegExp(
                        //           r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        //       .hasMatch(value)) {
                        //     return "Please enter a valid email address";
                        //   }
                        //   return null;
                        // },
                        onFieldSubmit: (value) {
                          // Utils.fieldFocusChange(
                          //   context,
                          //   viewModel.mobileFocusNode,
                          //   viewModel.signUpPasswordFocusNode,
                          // );
                        },
                      ),
                      buildVerticleSpace(12),
                      TextFieldWidget(
                        keyboardType: TextInputType.visiblePassword,
                        hintText: 'Password',
                        obscureText: true,
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          size: getProportionateScreenHeight(18),
                          color: ColorManager.primaryLight,
                        ),
                        sufixIcon: IconButton(
                          splashRadius: 1,
                          onPressed: () => {},
                          icon: Icon(
                            Icons.visibility,
                            size: getProportionateScreenHeight(20),
                            color: ColorManager.textGrey.withOpacity(0.6),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          } else if (value.length < 8) {
                            return 'Password should be 8 charators minimum';
                          }
                          return null;
                        },
                        onFieldSubmit: (value) {},
                      ),
                      buildVerticleSpace(12),
                      TextFieldWidget(
                        keyboardType: TextInputType.visiblePassword,
                        hintText: 'Confirm Password',
                        obscureText: true,
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          size: getProportionateScreenHeight(18),
                          color: ColorManager.primaryLight,
                        ),
                        sufixIcon: IconButton(
                          splashRadius: 1,
                          onPressed: () {},
                          icon: Icon(
                            Icons.visibility,
                            size: getProportionateScreenHeight(20),
                            color: ColorManager.textGrey.withOpacity(0.6),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm Password is required';
                          }
                          // else if (value !=
                          //     viewModel.signupPasswordController.text) {
                          //   return 'Password did\'t match';
                          // }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                // buildVerticleSpace(20),
                // _buildKeepMeSignIn(viewModel),
                buildVerticleSpace(70),
                // const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(75),
                  ),
                  child: AppButtonWidget(
                    ontap: () async {

                    },
                    child
                        // child: viewModel.isLoading == true
                        //     ? const Center(
                        //         child: CircularProgressIndicator(),
                        //       )
                        : const Text(
                      "Create Account",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: kTextBentonSansMed(
                    'Already have an account?',
                    color: ColorManager.primary,
                    fontSize: getProportionateScreenHeight(12),
                    textDecoration: TextDecoration.underline,
                  ),
                ),
                buildVerticleSpace(50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
