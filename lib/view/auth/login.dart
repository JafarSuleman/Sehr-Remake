import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/utils/text_manager.dart';
import '../../components/app_button_widget.dart';
import '../../components/home_button_component.dart';
import '../../components/loading_widget.dart';
import '../../components/logo_component.dart';
import '../../components/special_Package_Info_Dialog.dart';
import '../../components/text_field_component.dart';
import '../../utils/app/constant.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';
import '../../controller/user_controller.dart'; // Make sure to import UserController
import '../home/special_package_screen/special_package_screen.dart';
import '../profile/email_otp_screen.dart';
import '../profile/phone_otp_screen.dart';

class LoginView extends StatefulWidget {
  bool? isFromSpecialPackage = false;
  String? specialPackageName;
  String? selectedLocationId;

  LoginView({super.key,this.isFromSpecialPackage,this.specialPackageName,this.selectedLocationId});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _whatsAppController = TextEditingController();

  bool isPhoneFieldEnabled = true;
  bool isEmailFieldEnabled = true;
  bool isWhatsAppFieldEnabled = false;
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _whatsAppFocusNode = FocusNode();

  final _phoneFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _whatsAppFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isLoading2 = false;

  @override
  void initState() {
    super.initState();
    print("Login Screen Special Package ==> ${widget.isFromSpecialPackage}");
    print("Login Screen Special Package Id ==> ${widget.specialPackageName}");

    if (widget.isFromSpecialPackage == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please Login first to activate package'),
          ),
        );
      });
    }

    _blinkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Listeners to handle enabling/disabling fields
    _phoneNumberController.addListener(() {
      if (_phoneNumberController.text.isNotEmpty) {
        setState(() {
          isEmailFieldEnabled = false;
          isWhatsAppFieldEnabled = false;
          _emailFocusNode.unfocus();
          _whatsAppFocusNode.unfocus();
        });
      } else {
        setState(() {
          isEmailFieldEnabled = true;
          isWhatsAppFieldEnabled = true;
        });
      }
    });

    _emailController.addListener(() {
      if (_emailController.text.isNotEmpty) {
        setState(() {
          isPhoneFieldEnabled = false;
          isWhatsAppFieldEnabled = false;
          _whatsAppFocusNode.unfocus();
          _phoneFocusNode.unfocus();
        });
      } else {
        setState(() {
          isPhoneFieldEnabled = true;
          isWhatsAppFieldEnabled = true;
        });
      }
    });

    _whatsAppController.addListener(() {
      if (_whatsAppController.text.isNotEmpty) {
        setState(() {
          isPhoneFieldEnabled = false;
          isEmailFieldEnabled = false;
          _emailFocusNode.unfocus();
          _phoneFocusNode.unfocus();
        });
      } else {
        setState(() {
          isPhoneFieldEnabled = true;
          isEmailFieldEnabled = true;
        });
      }
    });

  }
  late AnimationController _blinkAnimationController;
  bool showBlinking = true;





  @override
  void dispose() {
    _phoneNumberController.dispose();
    _emailController.dispose();
    _whatsAppController.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _whatsAppFocusNode.dispose();
    _blinkAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Login Screen Special Package ==> ${widget.isFromSpecialPackage}");
    print("Login Screen Special Package Id ==> ${widget.specialPackageName}");
    // final viewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(34),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildVerticleSpace(80),
                const LogoWidget(),
                buildVerticleSpace(32),
                kTextBentonSansBold(
                  'Login To Your Account',
                  fontSize: getProportionateScreenHeight(20),
                ),
                buildVerticleSpace(20),
                widget.isFromSpecialPackage == true? const SizedBox.shrink():GestureDetector(
                  onTap: () {
                    specialPackageInfoDialog(context,widget.specialPackageName,true);
                  },
                  child: AnimatedBuilder(
                    animation: _blinkAnimationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: showBlinking ? _blinkAnimationController.value : 1.0,
                        child: const HomeButtonComponent(
                          btnColor: Colors.redAccent,
                          width: double.infinity,
                          imagePath: AppIcons.specialIcon,
                          iconColor: Colors.white,
                          btnTextColor: Colors.white,
                          name: "Special Package",
                        ),
                      );
                    },
                  ),
                ),

                buildVerticleSpace(30),
                // Phone Number Form and TextField
                Form(
                  key: _phoneFormKey,
                  child: TextFieldWidget(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    hintText: 'Enter Phone Or WhatsApp Number',
                    enabled: isPhoneFieldEnabled,
                    prefixIcon: Icon(
                      Icons.call,
                      size: getProportionateScreenHeight(18),
                      color: ColorManager.primaryLight,
                    ),
                    sufixIcon: Image.asset(
                            AppIcons.whatsappIcon,
                            color: ColorManager.primaryLight,
                            scale: 30,
                          ),
                    validator: _phoneNumberController.text.isNotEmpty
                        ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone is required';
                      }
                      // Add phone number validation logic here
                      // For example, check if it's a valid phone number format
                      if (!GetUtils.isPhoneNumber(value)) {
                        return 'Please enter a valid phone or whatsApp number';
                      }
                      return null;
                    }
                        : null,
                    focusNode: _phoneFocusNode,
                    onFieldSubmit: (value) {},
                  ),
                ),
                buildVerticleSpace(8),
                // const Text(
                //   'or',
                //   style: TextStyle(fontSize: 16),
                // ),
                // buildVerticleSpace(8),
                // // Email Form and TextField
                // Form(
                //   key: _whatsAppFormKey,
                //   child: TextFieldWidget(
                //     controller: _whatsAppController,
                //     keyboardType: TextInputType.number,
                //     hintText: 'Enter WhatsApp Number',
                //     enabled: false,
                //     prefixIcon: Image.asset(
                //       AppIcons.whatsappIcon,
                //       color: ColorManager.primaryLight,
                //       scale: 30,
                //     ),
                //     validator: isWhatsAppFieldEnabled
                //         ? (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'WhatsApp Number is required';
                //       }
                //       // Add phone number validation logic here
                //       // For example, check if it's a valid phone number format
                //       if (!GetUtils.isPhoneNumber(value)) {
                //         return 'Please enter a whatsApp number';
                //       }
                //       return null;
                //     }
                //         : null,
                //     focusNode: _whatsAppFocusNode,
                //     onFieldSubmit: (value) {},
                //   ),
                // ),
                // buildVerticleSpace(8),
                const Text(
                  'or',
                  style: TextStyle(fontSize: 16),
                ),
                buildVerticleSpace(8),
                // Email Form and TextField
                Form(
                  key: _emailFormKey,
                  child: TextFieldWidget(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter Email',
                    enabled: isEmailFieldEnabled,
                    prefixIcon: Icon(
                      Icons.email,
                      size: getProportionateScreenHeight(18),
                      color: ColorManager.primaryLight,
                    ),
                    validator: _emailController.text.isNotEmpty
                        ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      // Email validation logic using GetX
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    }
                        : null,
                    focusNode: _emailFocusNode,
                    onFieldSubmit: (value) {},
                  ),
                ),
                buildVerticleSpace(20),

                isEmailFieldEnabled ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(90),
                  ),
                  child: AppButtonWidget(
                    child:  isLoading
                        ? loadingSpinkit(Colors.white):const Text("Send Otp",style: TextStyle(color: Colors.white),),
                    ontap: () async {
                      setState(() {
                        isLoading = true;
                      });

                      if (_emailController.text.isNotEmpty) {
                        if (_emailFormKey.currentState!.validate()) {
                          // Email registration logic
                          String email = _emailController.text.trim();

                          print("Email from Login Screen ===> $email");

                          bool otpSent = await UserController().sendEmailOTP(email);
                          if (otpSent) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EmailVerificationCodeView(email: email,specialPackageName: widget.specialPackageName,selectedLocationId: widget.selectedLocationId,),
                              ),
                            );
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Failed to send OTP to email")),
                            );
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                ) :
                Column(children: [
                  AppButtonWidget(
                    width: 200,
                    child:  isLoading
                        ? loadingSpinkit(Colors.white):const Text("Send OTP Via Sms",style: TextStyle(color: Colors.white),),
                    ontap: () async {
                      setState(() {
                        isLoading = true;
                      });

                      if (_phoneNumberController.text.isNotEmpty) {
                        if (_phoneFormKey.currentState!.validate()) {
                          // Phone number registration logic
                          String phoneNumber = _phoneNumberController.text.trim();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  phoneNumberVerificationCodeView(phone: phoneNumber,specialPackageName: widget.specialPackageName,selectedLocationId: widget.selectedLocationId,),
                            ),
                          );
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  buildVerticleSpace(15),
                  AppButtonWidget(
                    width: 200,
                    child:  isLoading2
                        ? loadingSpinkit(Colors.white):const Center(child: Text("Send OTP Via WhatsApp",style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)),
                    ontap: () async {
                      setState(() {
                        isLoading2 = true;
                      });

                      if (_phoneNumberController.text.isNotEmpty) {
                        if (_phoneFormKey.currentState!.validate()) {
                          // Phone number registration logic
                          String phoneNumber = _phoneNumberController.text.trim();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  phoneNumberVerificationCodeView(phone: phoneNumber,specialPackageName: widget.specialPackageName,selectedLocationId: widget.selectedLocationId,),
                            ),
                          );
                        } else {
                          setState(() {
                            isLoading2 = false;
                          });
                        }
                      }
                    },
                  ),

                ],),
                buildVerticleSpace(30),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => showInfoDialog(context),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 209, 206, 206))),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info), // Info icon
                        const SizedBox(width: 8),
                        Text(
                          'سحر کیا ہے؟',
                          style: TextStyleManager.boldTextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}


void showInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'سحر کیا ہے؟',
              textAlign: TextAlign.right,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the left
            children: [
              const Text(
                'سحر (SEHR) ایک سادہ معاشی انقلاب کا فارمولا ہے.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'SEHR = Sober Economic and Housing Revolution',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'اس میں عام عوام اور خواص کو مکانوں کی قلت کا جو سامنا ہے اس کو کسی حد تک پورا کرنے کی کوشش کی جائے گی۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'اس میں شامل ہونے والے تمام ممبران کو ایک مکان بالکل فری دیا جائے گا۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'کسی بھی شخص سے مکان کے حوالے سے نہ کوئی فیس لی جائے گی۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'نہ عطیہ نه تحفہ اور نہ ہی انویسٹمنٹ لی جائے گی۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'یہ ایک انتہائی سادہ فارمولا ہے کہ صرف اپنی ماہوار خریداری کو ایک لائن پر لاتے ہوئے سحر کوڈ والی شاپس سے کریں تو آپ کی اپنی ضروریات کو پورا کرنے کے لئے خرچ کی گئی رقم آپ کے مکان کی قسط تصور ہوگی۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'کل 240 قسطیں ہوں گی، ایک قسط 10 ہزار روہے کی ہوگی۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'یہ وہ رقم ہوگی جو آپ اپنی روز مرہ کی خریداری سے خرچ کرتے ہیں۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'آپ نے سحر پروجیکٹ کو ایک روپیہ بھی ادا نہیں کرنا .',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'کسی بھی شعبہ سے تعلق رکھنے والے افراد اس میں شامل ہو کر حیران کن فوائد حاصل کر سکتے ہیں ۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'ہر شعبہ کے لیے آفرز نہ صرف حیران کن ہے بلکہ ناقابل عمل نظر آتی ہے، یہی اس پروجیکٹ کے منفرد یا innovative ہونے کا ثبوت بھی ہے۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'اس پروجیکٹ کو ڈیزائن کرنے والے پروفیسر منور احمد ملک ہیں جو پہلے ہی 50 سے زائد ایجادات کے موجد ہیں۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'پاکستان انجینئرنگ کونسل اسلام آباد کے تھنک ٹینک کے ممبر رہ چکے ہیں۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'نیشنل لیول پر بہت سے پروجیکٹ ڈیزائن کر چکے ہیں پچھلے 20 سال سے اس پروجیکٹ کو ترتیب دے رہے تھے ، اسے اکنامکس کے ماہرین قابل عمل قرار دے چکے ہیں ۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'یہ مکان ہر تحصیل میں پہلے سے موجود سوسائٹیز یا کالونیز میں پلاٹ لے کر بنائے جائیں گے اور پبلک کو فری دیئے جائیں گے۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              Text(
                'یہ منصوبہ اپنے اندر ایک معاشی انقلاب بھی رکھتا ہے جب اتنی بڑی معاشی سرگرمی ایک لائن پر آجائے گی تو قیمتیں بھی کنٹرول میں آجائیں گی مہنگائی ختم ہو کر منفی ہو جائے گی ان شاءاللہ، ڈالر کا ریٹ بھی کنٹرول ہو جائے گا اور بیرونی قرضوں سے بھی نجات ملے گی ان شاءاللہ ۔',
                style: TextStyleManager.regularTextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      );
    },
  );
}

class BgPatternWidget extends StatelessWidget {
  const BgPatternWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Image.asset(AppImages.pattern),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: getProportionateScreenHeight(300),
              ),
              child: Image.asset(AppImages.ellipse6),
            ),
          ),
        ],
      ),
    );
  }
}
