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
import 'dart:async';

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

    _bounceAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: 8.0,
    ).animate(
      CurvedAnimation(
        parent: _bounceAnimationController,
        curve: Curves.decelerate,
      ),
    );

    void performDoubleBounce() {
      if (!mounted) return;
      
      _bounceAnimationController.forward().then((_) {
        if (!mounted) return;
        _bounceAnimationController.reverse().then((_) {
          if (!mounted) return;
          Future.delayed(const Duration(milliseconds: 100), () {
            if (!mounted) return;
            _bounceAnimationController.forward().then((_) {
              if (!mounted) return;
              _bounceAnimationController.reverse();
            });
          });
        });
      });
    }

    performDoubleBounce();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      performDoubleBounce();
    });

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
  late AnimationController _bounceAnimationController;
  late Animation<double> _bounceAnimation;
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
    _bounceAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            SafeArea(
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
                      widget.isFromSpecialPackage == true || widget.isFromLogout == true
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: () {
                              specialPackageInfoDialog(
                                context,
                                widget.specialPackageName,
                                true,
                                _emailController.text.trim()
                              );
                            },
                            child: AnimatedBuilder(
                              animation: _bounceAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, -_bounceAnimation.value),
                                  child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.red.shade600,
                                          Colors.red.shade800,
                                          Colors.red.shade900,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppIcons.specialIcon,
                                          color: Colors.white,
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          "Special Package",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                      buildVerticleSpace(30),
                      Form(
                        key: _phoneFormKey,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            enabled: isPhoneFieldEnabled,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Phone Or WhatsApp Number',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15,
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.call,
                                  size: 20,
                                  color: ColorManager.primaryLight,
                                ),
                              ),
                              suffixIcon: Container(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  AppIcons.whatsappIcon,
                                  color: ColorManager.primaryLight,
                                  scale: 30,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
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
                          ),
                        ),
                      ),
                      buildVerticleSpace(12),
                      Form(
                        key: _emailFormKey,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: isEmailFieldEnabled,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Email',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15,
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.email,
                                  size: 20,
                                  color: ColorManager.primaryLight,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              enabled: isEmailFieldEnabled,
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
                          ),
                        ),
                      ),
                      buildVerticleSpace(40),

                      isEmailFieldEnabled ? 
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                              Colors.green.shade800,
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
                        width: double.infinity,  // Same width as text fields
                        child: AppButtonWidget(
                          height: 45,  // Slightly less than text fields
                          child: isLoading
                            ? loadingSpinkit(Colors.white)
                            : const Text(
                                "Send OTP",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

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
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.green.shade400,
                                  Colors.green.shade600,
                                  Colors.green.shade800,
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
                              height: 45,
                              child: isLoading
                                ? loadingSpinkit(Colors.white)
                                : const Text(
                                    "Send OTP Via SMS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

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
                          ),
                          buildVerticleSpace(15),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.green.shade400,
                                  Colors.green.shade600,
                                  Colors.green.shade800,
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
                              height: 45,
                              child: isLoading2
                                ? loadingSpinkit(Colors.white)
                                : const Text(
                                    "Send OTP Via WhatsApp",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
                          ),
                        ],
                      ),
                      buildVerticleSpace(30),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xff134250),
                              const Color(0xff12293c),
                              Colors.blue.shade800,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff134250).withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => showInfoDialog(context),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'سحر کیا ہے؟',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'UrduFont',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
                'ہر شعبہ کے لیے آفرز نہ صرف حیران کن ہے بلکہ ناقابل عمل ظر آتی ہے یہی اس پروجیکٹ کے منفرد یا innovative ہونے کا ثبوت بھی ہے۔',
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
