import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../components/app_button_widget.dart';
import '../../components/top_back_button_widget.dart';
import '../../utils/app/constant.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/routes/routes.dart';
import '../../utils/size_config.dart';

class UplaodProfilePhotoView extends StatefulWidget {
  const UplaodProfilePhotoView({super.key});

  @override
  State<UplaodProfilePhotoView> createState() => _UplaodProfilePhotoViewState();
}

class _UplaodProfilePhotoViewState extends State<UplaodProfilePhotoView> {
  XFile? image;

  @override
  Widget build(BuildContext context) {
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
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  'This data will be displayed in your\n\naccount profile for security',
                  fontSize: getProportionateScreenHeight(12),
                ),
              ),
              buildVerticleSpace(20),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(34),
                ),
                child: image == null
                    ? _buildImageUploadTypes(ImagePicker())
                    : _buildImagePreview(image),
              ),
              // buildVerticleSpace(40),
              const Spacer(),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(118),
                ),
                child: AppButtonWidget(
                  ontap: () async {
                    Get.toNamed(Routes.homeRoute);
                  },
                  text: 'Next',
                ),
              ),
              buildVerticleSpace(50),
            ])
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadTypes(ImagePicker picker) {
    return Column(
      children: [
        _buildCard(
          icon: AppIcons.galleryIcon,
          label: 'From Gallery',
          ontap: () {
            picker.pickImage(source: ImageSource.gallery);
          },
        ),
        buildVerticleSpace(20),
        _buildCard(
          icon: AppIcons.cameraIcon,
          label: 'Take Photo',
          ontap: () {
            picker.pickImage(source: ImageSource.camera);
          },
        ),
      ],
    );
  }

  Widget _buildImagePreview(XFile? file) {
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
                File(file!.path),
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
