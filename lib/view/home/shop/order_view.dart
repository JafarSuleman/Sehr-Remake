import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehr_remake/model/business_model.dart';
import 'package:http/http.dart' as http;
import 'package:sehr_remake/model/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/app_button_widget.dart';

import '../../../components/custom_chip_widget.dart';
import '../../../utils/app/constant.dart';

import '../../../utils/color_manager.dart';
import '../../../utils/size_config.dart';
import '../../../utils/text_manager.dart';

import 'package:flutter/widgets.dart';

import 'order_proccessing.dart';

class OrderPlacingView extends StatefulWidget {
  String identifier;
  BussinessModel model;
  OrderPlacingView(this.model, this.identifier);

  @override
  State<OrderPlacingView> createState() => _OrderPlacingViewState();
}

class _OrderPlacingViewState extends State<OrderPlacingView> {


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    amountcontroller.dispose();
    commentcontroller.dispose();
  }

  TextEditingController amountcontroller = TextEditingController();
  TextEditingController commentcontroller = TextEditingController();

  // BusinessModel businessModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          // color: ColorManager.white,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: SizeConfig.screenHeight * 0.7,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.only(
                      topLeft:
                          Radius.circular(getProportionateScreenHeight(30)),
                      topRight:
                          Radius.circular(getProportionateScreenHeight(30)),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(24),
                      vertical: getProportionateScreenWidth(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //    buildVerticleSpace(40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomChipWidget(text: 'Popular'),
                            CircleAvatar(
                              radius: getProportionateScreenHeight(17),
                              backgroundColor:
                                  ColorManager.error.withOpacity(0.1),
                              child: Icon(
                                Icons.favorite_rounded,
                                color: ColorManager.errorLight,
                                size: getProportionateScreenHeight(20),
                              ),
                            ),
                          ],
                        ),
                        buildVerticleSpace(20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kTextBentonSansMed(
                              // '${businessModel.businessName}',
                              widget.model.businessName.toString(),
                              fontSize: getProportionateScreenHeight(27),
                            ),
                            kTextBentonSansMed(
                                // '${businessModel.businessName}',
                                "Owner Name : ${widget.model.ownerName}",
                                fontSize: getProportionateScreenHeight(12),
                                color: Colors.grey),

                            buildVerticleSpace(10),
                            SizedBox(
                              height: getProportionateScreenHeight(88),
                              child: kTextBentonSansMed(
                                widget.model.about.toString(),
                                height: 1.5,
                                maxLines: 4,
                                overFlow: TextOverflow.ellipsis,
                              ),
                            ),
                            buildVerticleSpace(20),
                            Container(
                              padding: EdgeInsets.all(
                                getProportionateScreenHeight(12),
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.primary,
                                borderRadius: BorderRadius.circular(
                                  getProportionateScreenHeight(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 0,
                                    margin: EdgeInsets.only(
                                      top: getProportionateScreenHeight(8),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        getProportionateScreenHeight(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        getProportionateScreenHeight(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          kTextBentonSansMed(
                                            '  Enter Total Amount',
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    16),
                                          ),
                                          buildVerticleSpace(10),
                                          TextFormField(
                                            controller: amountcontroller,
                                            keyboardType: TextInputType.number,
                                            style: TextStyleManager
                                                .regularTextStyle(
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      14),
                                              letterSpacing:
                                                  getProportionateScreenHeight(
                                                      0.5),
                                            ),
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: ColorManager.lightGrey,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal:
                                                    getProportionateScreenWidth(
                                                        20),
                                                vertical:
                                                    getProportionateScreenHeight(
                                                        10),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              // hintText: 'amount',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  buildVerticleSpace(10),
                                  AppButtonWidget(
                                    ontap: () async {
                                      print(widget.model.id);
                                      print(amountcontroller.text);
                                      print("User Id in order view ==> ${widget.identifier}");
                                      // SharedPreferences prefs = await SharedPreferences.getInstance();
                                      // String authMethod = prefs.getString('authMethod') ?? '';
                                      // String apiIdentifier = (authMethod == 'email') ? widget.identifier : widget.identifier.replaceFirst("+92", "0");
                                      //
                                      // print(FirebaseAuth
                                      //     .instance.currentUser!.phoneNumber);
                                      try {
                                        var response = await http.post(
                                            Uri.parse(
                                                "${Constants.BASE_URL}${Constants.PLACE_ORDER}"),
                                            headers: {
                                              'Content-Type': 'application/json'
                                            },
                                            body: jsonEncode({
                                              "shopid":
                                                  widget.model.id.toString(),
                                              "userid": widget.identifier.toString(),
                                              "amount": int.parse(
                                                  amountcontroller.text)
                                            }));
                                        print(response.body);

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const OrderProcessingView()),
                                        );
                                      } catch (e) {
                                        print(e.toString());
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e.toString())));
                                      }
                                    },
                                    bgColor: ColorManager.white,
                                    // text: 'Verify My Order',
                                    // textColor: ColorManager.primary,
                                    child: kTextBentonSansBold(
                                      'Verify My Order',
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Row(
                            //   children: [
                            //     AppButtonWidget(
                            //       ontap: () {},
                            //       height: getProportionateScreenHeight(26),
                            //       width: getProportionateScreenWidth(72),
                            //       borderRadius: getProportionateScreenHeight(18),
                            //       text: 'Contact',
                            //       textSize: getProportionateScreenHeight(12),
                            //       letterSpacing: getProportionateScreenWidth(0.5),
                            //     ),
                            //     const Spacer(),
                            //     AppButtonWidget(
                            //       ontap: () {
                            //         // Get.off(MapDirection(
                            //         //   destLatitude: double.parse(
                            //         //       businessModel.lat.toString()),
                            //         //   destLongitude: double.parse(
                            //         //       businessModel.lon.toString()),
                            //         // ));
                            //       },
                            //       height: getProportionateScreenHeight(26),
                            //       width: getProportionateScreenWidth(115),
                            //       borderRadius: getProportionateScreenHeight(18),
                            //       text: 'Get Direction ↗',
                            //       textSize: getProportionateScreenHeight(12),
                            //       letterSpacing: getProportionateScreenWidth(0.5),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ],
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
}
