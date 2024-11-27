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
        body: SizedBox(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      // color: ColorManager.white,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: ColorManager.primary,
              height: getProportionateScreenHeight(350),
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl:
                    "${Constants.BASE_URL}/${widget.model.logo.toString()}",
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Image.asset("assets/images/shop.jpg", fit: BoxFit.fill),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/shop.jpg", fit: BoxFit.fill),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: SizeConfig.screenHeight * 0.55,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(getProportionateScreenHeight(30)),
                  topRight: Radius.circular(getProportionateScreenHeight(30)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(20),
                  horizontal: getProportionateScreenWidth(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // widget.businessModel.isFavourite != true
                            //     ? getxcontroller.addToFavourite(
                            //         widget.businessModel.id)
                            //     : getxcontroller.deleteFromFavourite(
                            //         widget.businessModel.id);
                            // var bools =
                            //     widget.businessModel.isFavourite ==
                            //             true
                            //         ? false
                            //         : true;
                            // // getxcontroller.toggleFav(
                            // //     filterbussinessshops![index].id
                            // //         as int,
                            // //     filterbussinessshops![index]
                            // //         .isFavourite as bool);
                            // widget.businessModel.isFavourite = bools;
                            // for (var business
                            //     in getxcontroller.business) {
                            //   if (widget.businessModel.id ==
                            //       business.id) {
                            //     business.isFavourite = bools;
                            //   }
                            // }
                            // if (mounted) {
                            //   setState(() {});
                            // }
                          },
                          child: CircleAvatar(
                            radius: getProportionateScreenHeight(17),
                            backgroundColor:
                                ColorManager.error.withOpacity(0.1),
                            child: Icon(
                              Icons.favorite_border_rounded,
                              color: ColorManager.errorLight,
                              size: getProportionateScreenHeight(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    buildVerticleSpace(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kTextBentonSansMed(
                          widget.model.businessName.toString(),
                          fontSize: getProportionateScreenHeight(27),
                        ),
                        buildVerticleSpace(20),
                        Row(
                          children: [
                            kTextBentonSansMed(
                              'Sehr Code : ',
                            ),
                            kTextBentonSansMed(
                              widget.model.sehrCode.toString() ??
                                  "Non Sehr Coded Shop",
                            ),
                          ],
                        ),
                        buildVerticleSpace(20),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: ColorManager.primaryLight,
                            ),
                            buildHorizontalSpace(13),
                            kTextBentonSansReg(
                              widget.distance,
                              color: ColorManager.textGrey.withOpacity(0.8),
                            ),
                          ],
                        ),
                        buildVerticleSpace(20),
                        kTextBentonSansMed(
                          widget.model.about.toString(),
                          height: 1.5,
                          maxLines: 6,
                          overFlow: TextOverflow.ellipsis,
                        ),
                        buildVerticleSpace(20),
                        Column(
                          children: [
                            Row(
                              children: [
                                AppButtonWidget(
                                  ontap: () {
                                    contactusdialog(context,
                                        widget.model.mobile.toString());
                                  },
                                  height: getProportionateScreenHeight(40),
                                  width: getProportionateScreenWidth(140),
                                  borderRadius:
                                      getProportionateScreenHeight(18),
                                  text: 'Contact',
                                  textSize: getProportionateScreenHeight(12),
                                  letterSpacing:
                                      getProportionateScreenWidth(0.5),
                                ),
                                const Spacer(),
                                AppButtonWidget(
                                  ontap: _launchNavigationInMap,
                                  height: getProportionateScreenHeight(40),
                                  width: getProportionateScreenWidth(140),
                                  borderRadius:
                                      getProportionateScreenHeight(18),
                                  text: 'GO to Shop ↗',
                                  textSize: getProportionateScreenHeight(12),
                                  letterSpacing:
                                      getProportionateScreenWidth(0.5),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AppButtonWidget(
                              ontap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderPlacingView(widget.model,  widget.identifier,),
                                    ));
                              },
                              height: getProportionateScreenHeight(40),
                              width: getProportionateScreenWidth(140),
                              borderRadius: getProportionateScreenHeight(18),
                              text: 'Place Order',
                              textSize: getProportionateScreenHeight(12),
                              letterSpacing: getProportionateScreenWidth(0.5),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
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
