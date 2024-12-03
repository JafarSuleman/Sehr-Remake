import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sehr_remake/controller/user_controller.dart';
import 'package:sehr_remake/model/user_model.dart' as userModel;
import 'package:sehr_remake/utils/auth_check/data_check.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/app_button_widget.dart';
import '../../components/loading_widget.dart';
import '../../components/top_back_widget.dart';
import '../../utils/app/constant.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';
import '../home/home.dart';

class UploadProfilePhotoView extends StatefulWidget {
  final userModel.User user;
  final String? email;
  const UploadProfilePhotoView({super.key, required this.user,this.email});

  @override
  State<UploadProfilePhotoView> createState() => _UploadProfilePhotoViewState();
}

class _UploadProfilePhotoViewState extends State<UploadProfilePhotoView> {
  bool isLoading = false;
  XFile? file;

  @override
  Widget build(BuildContext context) {
    print("Special Package Location Id In UploadProfile PhotoView Screen ==> ${widget.user.selectedLocationId}");
    print("Special Email In UploadProfile PhotoView Screen ==> ${widget.email}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                SizedBox(height: 30,),
                const TopBackButtonWidget(),
                buildVerticleSpace(24),
                Padding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(27),
                  ),
                  child: kTextBentonSansMed(
                    'Upload Your Profile\nPhoto',
                    fontSize: getProportionateScreenHeight(25),
                  ),
                ),
                buildVerticleSpace(52),
                Padding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(27),
                  ),
                  child: kTextBentonSansMed(
                    'This data will be displayed in your\naccount profile for security',
                    fontSize: getProportionateScreenHeight(15),
                  ),
                ),
                buildVerticleSpace(40),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(34),
                  ),
                  child: file == null
                      ? _buildImageUploadTypes()
                      : _buildImagePreview(file),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(35),
                  ),
                  child: Container(
                    width: double.infinity,
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
                    child: AppButtonWidget(
                      ontap: () async {
                        if (file == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Add An Image First")));
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String authMethod = prefs.getString('authMethod') ?? '';
                        String mobile;

                        // if (authMethod == 'phone') {
                        //   mobile = prefs.getString('identifier')!;
                        // } else {
                        //   mobile = widget.user.mobile!;
                        // }

                        print("Email ==> ${widget.email}");
                        print("Phone Number ==> ${widget.user.mobile}");
                        print("Location In Upload Photo ==> ${widget.user.selectedLocationId}");

                        userModel.User userData = userModel.User(
                          firstName: widget.user.firstName,
                          lastName: widget.user.lastName,
                          cnic: widget.user.cnic,
                          mobile: widget.user.mobile,
                          education: widget.user.education,
                          address: widget.user.address,
                          tehsil: widget.user.tehsil,
                          district: widget.user.district,
                          province: widget.user.province,
                          division: widget.user.division,
                          package: widget.user.package,
                          specialPackage: widget.user.specialPackage,
                          email: widget.email,
                          selectedLocationId: widget.user.selectedLocationId
                        );

                        String res = await UserController().createUserData(userData, file as XFile);

                        setState(() {
                          isLoading = false;
                        });

                        if (res == "User has Been Registered") {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                                (Route<dynamic> route) => false, // This removes all previous routes
                          );

                        } else {
                          // Display error and remain on the screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(res)),
                          );
                        }
                      },
                      child: isLoading
                          ? loadingSpinkit(Colors.white)
                          : const Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600,fontSize: 20),
                      ),
                    ),
                  ),
                ),
                buildVerticleSpace(50),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadTypes() {
    return Column(
      children: [
        _buildCard(
          icon: AppIcons.galleryIcon,
          label: 'From Gallery',
          ontap: () async {
            var image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                file = image;
              });
            }
          },
        ),
        buildVerticleSpace(20),
        _buildCard(
          icon: AppIcons.cameraIcon,
          label: 'Take Photo',
          ontap: () async {
            var image =
            await ImagePicker().pickImage(source: ImageSource.camera);
            if (image != null) {
              setState(() {
                file = image;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildImagePreview(XFile? image) {
    return Padding(
      padding: EdgeInsets.only(bottom: getProportionateScreenHeight(60)),
      child: Center(
        child: Container(
          height: getProportionateScreenHeight(260),
          width: getProportionateScreenWidth(250),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.02),
                blurRadius: 2,
                spreadRadius: 8,
              ),
              BoxShadow(
                color: Colors.green.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 8,
              ),
            ],
            image: DecorationImage(
              image: Image.file(
                height: getProportionateScreenHeight(260),
                width: getProportionateScreenWidth(250),
                File(image!.path),
              ).image,
              fit: BoxFit.cover,
            ),

          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenHeight(18),
                    vertical: getProportionateScreenHeight(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        file = null;
                      });
                    },
                    child: Image.asset(
                      AppIcons.closeIcon,
                      height: getProportionateScreenHeight(31),
                      width: getProportionateScreenHeight(31),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String icon,
    required String label,
    void Function()? ontap,
  }) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: getProportionateScreenHeight(150),
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.9),
              Colors.white.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.03),
              blurRadius: 5,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: getProportionateScreenHeight(50),
              width: getProportionateScreenHeight(50),
            ),
            buildVerticleSpace(9),
            kTextBentonSansMed(label),
          ],
        ),
      ),
    );
  }
}
