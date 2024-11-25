import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/utils/text_manager.dart';
import '../../components/app_button_widget.dart';
import '../../components/home_button_component.dart';
import '../../components/loading_widget.dart';
import '../../components/logo_component.dart';
import '../../components/special_Package_Info_Dialog.dart';
import '../../components/text_field_component.dart';
import '../../controller/auth_controller.dart';
import '../../utils/app/constant.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';
import '../../controller/user_controller.dart';
import '../profile/email_otp_screen.dart';
import '../profile/phone_otp_screen.dart';

class LoginView extends StatefulWidget {
  bool? isFromSpecialPackage = false;
  String? specialPackageName;
  String? selectedLocationId;
  bool? isFromLogout = false;


  LoginView({super.key,this.isFromSpecialPackage,this.specialPackageName,this.selectedLocationId,this.isFromLogout});

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
  bool isLoading = false;
  bool isLoading2 = false;

  Future<void> _sendWhatsAppOTP() async {
    setState(() {
      isLoading2 = true;
    });

    String phone = _phoneNumberController.text.startsWith('0')
        ? _phoneNumberController.text.replaceFirst('0', '+92')
        : _phoneNumberController.text;

    try {
      final response = await http.post(
        Uri.parse('${Constants.BASE_URL}${Constants.SEND_WHATSAPP_OTP}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'whatsappNumber': phone,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP sent via WhatsApp")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => phoneNumberVerificationCodeView(
              specialPackageName: widget.specialPackageName,
              selectedLocationId: widget.selectedLocationId,
                phone: phone,
                isWhatsApp: true,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to send WhatsApp OTP.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send WhatsApp OTP.")),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error sending WhatsApp OTP.")),
      );
    } finally {
      setState(() {
        isLoading2 = false;
      });
    }
  }

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
  bool? isWhatsApp = false;
  final AuthController authController = Get.put(AuthController());




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
                widget.isFromSpecialPackage == true || widget.isFromLogout == true? const SizedBox.shrink():GestureDetector(
                  onTap: () {
                    specialPackageInfoDialog(context,widget.specialPackageName,true,_emailController.text.trim());
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
                const Text(
                  'or',
                  style: TextStyle(fontSize: 16),
                ),
                buildVerticleSpace(8),
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
                          String email = _emailController.text.trim();

                          print("Email from Login Screen ===> $email");

                          bool otpSent = await UserController().sendEmailOTP(email);
                          if (otpSent) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EmailVerificationCodeView(email: email,specialPackageName: widget.specialPackageName,selectedLocationId: widget.selectedLocationId,),
                              ),
                            );
                            setState(() {
                              isLoading = false;
                            });
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
                          String phoneNumber = _phoneNumberController.text.trim();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  phoneNumberVerificationCodeView(phone: phoneNumber,specialPackageName: widget.specialPackageName,selectedLocationId: widget.selectedLocationId,isWhatsApp: false,),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  buildVerticleSpace(15),
                  // Obx(() => AppButtonWidget(
                  //   width: 200,
                  //   child: authController.isLoading.value
                  //       ? loadingSpinkit(Colors.white)
                  //       : const Text("Send OTP Via WhatsApp", style: TextStyle(color: Colors.white)),
                  //   ontap: () {
                  //     if (_phoneNumberController.text.isNotEmpty) {
                  //       authController.sendWhatsAppOTP(
                  //         context,
                  //         _phoneNumberController.text.trim(),
                  //         widget.specialPackageName,
                  //         widget.selectedLocationId,
                  //       );
                  //     } else {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(content: Text("Please enter a phone number")),
                  //       );
                  //     }
                  //   },
                  // )),
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
                          await _sendWhatsAppOTP();
                          setState(() {
                            isLoading2 = false;
                          });
                        }
                      } else {
                        setState(() {
                          isLoading2 = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter a phone number")),
                        );
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
        title: const Center(
          child: Text(
            'سحر کیا ہے؟',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'UrduFont',
              fontSize: 34,
            ),
          ),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                'سحر (SEHR) ایک سادہ معاشی انقلاب کا فارمولا ہے.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'SEHR = Sober Economic and Housing Revolution',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'اس میں عام عوام اور خواص کو مکانوں کی قلت کا جو سامنا ہے اس کو کسی حد تک پورا کرنے کی کوشش کی جائے گی۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,

              ),
              SizedBox(height: 5,),
              Text(
                'اس میں شامل ہونے والے تمام ممبران کو ایک مکان بالکل فری دیا جائے گا۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'کسی بھی شخص سے مکان کے حوالے سے نہ کوئی فیس لی جائے گی۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text('نہ عطیہ نہ تحفہ اور نہ ہی انویسٹمنٹ لی جائے گی۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'یہ ایک انتہائی سادہ فارمولا ہے کہ صرف اپنی ماہوار خریداری کو ایک لائن پر لاتے ہوئے سحر کوڈ والی شاپس سے کریں تو آپ کی اپنی ضروریات کو پورا کرنے کے لئے خرچ کی گئی رقم آپ کے مکان کی قسط تصور ہوگی۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'کل 240 قسطیں ہوں گی، ایک قسط 10 ہزار روہے کی ہوگی۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'یہ وہ رقم ہوگی جو آپ اپنی روز مرہ کی خریداری سے خرچ کرتے ہیں۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'آپ نے سحر پروجیکٹ کو ایک روپیہ بھی ادا نہیں کرنا ۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'کسی بھی شعبہ سے تعلق رکھنے والے افراد اس میں شامل ہو کر حیران کن فوائد حاصل کر سکتے ہیں ۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'ہر شعبہ کے لیے آفرز نہ صرف حیران کن ہے بلکہ ناقابل عمل نظر آتی ہے، یہی اس پروجیکٹ کے منفرد یا innovative ہونے کا ثبوت بھی ہے۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'اس پروجیکٹ کو ڈیزائن کرنے والے پروفیسر منور احمد ملک ہیں جو پہلے ہی 50 سے زائد ایجادات کے موجد ہیں۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'پاکستان انجینئرنگ کونسل اسلام آباد کے تھنک ٹینک کے ممبر رہ چکے ہیں۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'نیشنل لیول پر بہت سے پروجیکٹ ڈیزائن کر چکے ہیں پچھلے 20 سال سے اس پروجیکٹ کو ترتیب دے رہے تھے ، اسے اکنامکس کے ماہرین قابل عمل قرار دے چکے ہیں ۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'یہ مکان ہر تحصیل میں پہلے سے موجود سوسائٹیز یا کالونیز میں پلاٹ لے کر بنائے جائیں گے اور پبلک کو فری دیئے جائیں گے۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 5,),
              Text(
                'یہ منصوبہ اپنے اندر ایک معاشی انقلاب بھی رکھتا ہے جب اتنی بڑی معاشی سرگرمی ایک لائن پر آجائے گی تو قیمتیں بھی کنٹرول میں آجائیں گی مہنگائی ختم ہو کر منفی ہو جائے گی ان شآءاللہ، ڈالر کا ریٹ بھی کنٹرول ہو جائے گا اور بیرونی قرضوں سے بھی نجات ملے گی ان شاءاللہ ۔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.redAccent
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'بند کریں', // 'Close' in Urdu
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 24, fontFamily: 'UrduFont', color: Colors.white),
              ),
            ),
          ),
        ],
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
