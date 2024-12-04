import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/model/business_model.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

import '../../../components/app_button_widget.dart';
import '../../../components/button_contact_componenet.dart';
import '../../../utils/app/constant.dart';
import '../../../utils/asset_manager.dart';
import '../../../utils/color_manager.dart';
import '../../../utils/size_config.dart';
import '../../../utils/text_manager.dart';
import 'order_view.dart';

// ignore: must_be_immutable
class ShopDetailsView extends StatefulWidget {
  String identifier;
  final BussinessModel model;
  final String distance;
  ShopDetailsView({required this.model, required this.distance, required this.identifier});
  @override
  State<ShopDetailsView> createState() => _ShopDetailsViewState();
}

class _ShopDetailsViewState extends State<ShopDetailsView> {
  _launchNavigationInMap() async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=&destination=${widget.model.lat},${widget.model.lon}&travelmode=driving';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorManager.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios, color: ColorManager.primary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Hero Image
                Container(
                  height: getProportionateScreenHeight(420),
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: "${Constants.BASE_URL}/${widget.model.logo}",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Image.asset("assets/images/shop.jpg", fit: BoxFit.cover),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/images/shop.jpg", fit: BoxFit.cover),
                  ),
                ),
                // Content Container
                Container(
                  margin: EdgeInsets.only(top: getProportionateScreenHeight(380)),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(getProportionateScreenHeight(30)),
                      topRight: Radius.circular(getProportionateScreenHeight(30)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kTextBentonSansMed(
                                    widget.model.businessName.toString(),
                                    fontSize: getProportionateScreenHeight(24),
                                    color: ColorManager.primary,
                                  ),
                                  SizedBox(height: getProportionateScreenHeight(8)),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 18,
                                        color: ColorManager.primaryLight,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: kTextBentonSansReg(
                                          widget.distance,
                                          color: ColorManager.textGrey,
                                          fontSize: getProportionateScreenHeight(14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Favorite functionality remains the same...
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColorManager.error.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite_border_rounded,
                                  color: ColorManager.errorLight,
                                  size: getProportionateScreenHeight(24),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(height: getProportionateScreenHeight(30)),
                        // Sehr Code Section
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ColorManager.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color: Colors.green.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.qr_code,
                                color: ColorManager.primary,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kTextBentonSansMed(
                                    'Sehr Code',
                                    fontSize: getProportionateScreenHeight(14),
                                    color: ColorManager.primary,
                                  ),
                                  kTextBentonSansMed(
                                    widget.model.sehrCode?.toString() ?? "Non Sehr Coded Shop",
                                    fontSize: getProportionateScreenHeight(16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        // About Section
                        Center(
                          child: kTextBentonSansMed(
                            'About',
                            fontSize: getProportionateScreenHeight(18),
                            color: ColorManager.primary,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(8)),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ColorManager.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 1,
                                color: Colors.green.withOpacity(0.5),
                              ),
                            ),
                            child: kTextBentonSansReg(
                              widget.model.about.toString(),
                              lineHeight: 1.5,
                              maxLines: 6,
                              textOverFlow: TextOverflow.ellipsis,
                              color: ColorManager.textGrey,
                            ),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: AppButtonWidget(
                                ontap: () => contactusdialog(context, widget.model.mobile.toString()),
                                height: getProportionateScreenHeight(50),
                                borderRadius: getProportionateScreenHeight(12),
                                text: 'Contact',
                                textSize: getProportionateScreenHeight(14),
                                bgColor: ColorManager.primary.withOpacity(0.1),
                                textColor: ColorManager.primary,
                                border: true,
                              ),
                            ),
                            SizedBox(width: getProportionateScreenWidth(16)),
                            Expanded(
                              child: AppButtonWidget(
                                ontap: _launchNavigationInMap,
                                height: getProportionateScreenHeight(50),
                                borderRadius: getProportionateScreenHeight(12),
                                text: 'Go To Shop ↗',
                                textSize: getProportionateScreenHeight(14),
                                bgColor: ColorManager.primary.withOpacity(0.1),
                                textColor: ColorManager.primary,
                                border: true,


                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(16)),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade900,
                                Colors.green.shade500,
                                Colors.green.shade900,
                              ],
                            ),
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
                            ontap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderPlacingView(widget.model, widget.identifier),
                                ),
                              );
                            },
                            height: getProportionateScreenHeight(50),
                            borderRadius: getProportionateScreenHeight(12),
                            text: 'Place Order',
                            textSize: getProportionateScreenHeight(16),
                          ),
                        ),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

contactusdialog(BuildContext context, String phone) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Contact Shop",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "For further questions, contact using our contact Phone."),
              const SizedBox(
                height: 15,
              ),
              ButtonContact(
                  title: phone,
                  onPressed: () {
                    UrlLauncher.launch("tel://$phone");
                  },
                  color: HexColor.fromHex('#15BE77')),
              Container(),
            ],
          ),
        );
      });
}
