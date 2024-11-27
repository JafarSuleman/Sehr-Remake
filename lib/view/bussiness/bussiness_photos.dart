import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import 'package:sehr_remake/controller/package_controller.dart';
import 'package:sehr_remake/controller/user_controller.dart';
import 'package:sehr_remake/utils/auth_check/bussiness_data_check.dart';
import 'package:sehr_remake/view/bussiness/home/registeration/bussinessPackages.dart';
import '../../model/business_model.dart';
import 'package:sehr_remake/utils/auth_check/data_check.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../components/app_button_widget.dart';
import '../../components/top_back_widget.dart';
import '../../utils/app/constant.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';

class UploadBussinessPhoto extends StatefulWidget {
  String? identifier;
  final BussinessModel model;
   UploadBussinessPhoto({super.key, required this.model, required this.identifier});

  @override
  State<UploadBussinessPhoto> createState() => _UplaodProfilePhotoViewState();
}

class _UplaodProfilePhotoViewState extends State<UploadBussinessPhoto> {
  bool isLoading = false;
  XFile? file;
  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserController>().userModel;
    // final profileType =
    //     Provider.of<ProfileViewModel>(context, listen: false).selectedUserRole;
    return SafeArea(
      child: Scaffold(
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
                buildVerticleSpace(24),
                Padding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(27),
                  ),
                  child: kTextBentonSansMed(
                    'Upload Shop Profile\nPhoto',
                    fontSize: getProportionateScreenHeight(25),
                  ),
                ),
                buildVerticleSpace(52),
                Padding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(27),
                  ),
                  child: kTextBentonSansMed(
                    'This data will be displayed in your\n\naccount profile for security',
                    fontSize: getProportionateScreenHeight(12),
                  ),
                ),
                buildVerticleSpace(20),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(34),
                  ),
                  child: file == null
                      ? _buildImageUploadTypes()
                      : _buildImagePreview(file),
                ),
                // buildVerticleSpace(40),
                const Spacer(),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(118),
                  ),
                  child: AppButtonWidget(
                    ontap: () async {
                      if (file == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Add An Image First")));
                        return;
                      }

                      if (user.package == "653e1c4c9818104d6fc5797f" ||
                          user.package == "653e1c4c9818104d6fc57980" ||
                          user.package == "653e1c4c9818104d6fc57981" ||
                          user.package == "653e1c4c9818104d6fc57988" ||
                          user.package == "653e1e979818104d6fc5798b") {
                        setState(() {
                          isLoading = true;
                        });

                        String res = await BussinessController()
                            .createBussinessData(widget.model, file as XFile,widget.identifier!);

                        setState(() {
                          isLoading = false;
                        });

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckForBusinessData(identifier: widget.identifier,),
                            ));
                        print(res);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BussinessPackageScreen(
                                identifier: widget.identifier,
                                  bussinessModel: widget.model,
                                  imgFile: file as XFile),
                            ));
                      }
                    },
                    text: 'Next',
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
            image: DecorationImage(
              image: Image.file(
                height: getProportionateScreenHeight(260),
                width: getProportionateScreenWidth(250),
                File(image!.path),
              ).image,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
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
                    //  onTap: () => viewModel.cancelProfileImage(),
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
        height: getProportionateScreenHeight(129),
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(
            getProportionateScreenHeight(15),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withOpacity(0.05),
              blurRadius: getProportionateScreenHeight(15),
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
