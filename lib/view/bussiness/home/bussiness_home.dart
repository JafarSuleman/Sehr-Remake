import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/components/bussinessDrawerComponent.dart';
import 'package:sehr_remake/components/drawer_component.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import 'package:sehr_remake/controller/category_controller.dart';
import 'package:sehr_remake/controller/commission_Controller.dart';
import 'package:sehr_remake/controller/order_controller.dart';
import 'package:sehr_remake/controller/user_controller.dart';
import 'package:sehr_remake/model/order_model.dart';
import 'package:sehr_remake/utils/color_manager.dart';
import 'package:sehr_remake/utils/text_manager.dart';

import '../../../components/custom_card_widget.dart';
import '../../../components/custom_chip_widget.dart';
import '../../../utils/app/constant.dart';
import '../../../utils/asset_manager.dart';
import '../../../utils/size_config.dart';

class BusinessHomeScreen extends StatefulWidget {
  const BusinessHomeScreen({super.key});

  @override
  State<BusinessHomeScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  Timer? timeToLoadOrders;
  @override
  void initState() {
    context
        .read<BussinessController>()
        .getBussinessData(
            FirebaseAuth.instance.currentUser!.phoneNumber.toString())
        .then((value) {
      var bussinessData = context.read<BussinessController>().singleShopData;
      context
          .read<CommissionController>()
          .getCommissionAndSaleDetail(bussinessData.id.toString());
      Timer.periodic(Duration(seconds: 3), (timer) {
        context
            .read<OrderController>()
            .getShopOrders(bussinessData.id.toString());
      });
    });

    // timeToLoadOrders = Timer.periodic(Duration(seconds: 2), (timer) {
    //   context
    //       .read<OrderController>()
    //       .getShopOrders(bussinessData.id.toString());
    // });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timeToLoadOrders!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bussinessData = context.watch<BussinessController>().singleShopData;

    List<OrderModel> orders = context.watch<OrderController>().shopOrders;

    return Scaffold(
        drawer: BussinessDrawer(
          name: bussinessData.businessName.toString(),
          phone: bussinessData.mobile.toString(),
          imgUrl: bussinessData.logo.toString(),
        ),
        appBar: AppBar(
          backgroundColor: ColorManager.gradient2,
          title: Text("Your Orders"),
        ),
        body: orders.isEmpty
            ? Center(
                child: Text("No Orders Yet !",
                    style: TextStyleManager.mediumTextStyle(
                        color: ColorManager.textGrey, fontSize: 16)))
            : FutureBuilder(
                future: UserController().getSelectedUser(orders),
                builder: (context, snapshot) => ListView.builder(
                    itemCount: orders.reversed.length,
                    itemBuilder: (context, index) {
                      // context
                      //     .read<BussinessController>()
                      //     .getBussinesssById(orders[index].shopid.toString());
                      // var shopData = context
                      //     .watch<BussinessController>()
                      //     .singleBussinessData;
                      return CustomListTileWidget(
                          leading: SizedBox(
                            height: getProportionateScreenHeight(60),
                            width: getProportionateScreenWidth(60),
                            child: Image.network(
                              "${Constants.BASE_URL}/${snapshot.data!.reversed.toList()[index].avatar.toString()}",
                              fit: BoxFit.cover,
                              errorBuilder: (context,
                                      e,
                                      // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                                      StackTrace) =>
                                  Image.network(
                                "https://www.nicepng.com/png/detail/933-9332131_profile-picture-default-png.png",
                                fit: BoxFit.fill,
                              ),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              kTextBentonSansMed(
                                // filterlisttype[index]['name'],
                                snapshot.data!.reversed
                                    .toList()[index]
                                    .firstName
                                    .toString(),
                                fontSize: getProportionateScreenHeight(15),
                                overFlow: TextOverflow.ellipsis,
                              ),
                              // buildVerticleSpace(4),
                              kTextBentonSansReg(
                                DateFormat("yyyy-MM-dd")
                                    .format(DateTime.parse(orders.reversed
                                        .toList()[index]
                                        .date
                                        .toString()))
                                    .toString(),
                                // filterlisttype[index]["date"],
                                color: ColorManager.textGrey.withOpacity(0.8),
                                letterSpacing: getProportionateScreenWidth(0.5),
                              ),
                              // buildVerticleSpace(8),
                              kTextBentonSansMed(
                                'RS ${orders.reversed.toList()[index].amount}',
                                color: ColorManager.primary,
                                fontSize: getProportionateScreenHeight(16),
                              ),
                            ],
                          ),
                          trailing: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _showAcceptOrderDialog(
                                    context,
                                    "Conform Acceptance",
                                    "Are you sure you want to accept this order of  Rs ${orders.reversed.toList()[index].amount}",
                                    index,
                                    true,
                                    bussinessData.categoryId.toString(),
                                    bussinessData.id.toString(),
                                    orders,
                                  );
                                },
                                child: Text("Accept"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorManager.gradient2),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _showAcceptOrderDialog(
                                      context,
                                      "Conform Rejection",
                                      "Are you sure you want to reject this order of  Rs ${orders.reversed.toList()[index].amount}",
                                      index,
                                      false,
                                      bussinessData.categoryId.toString(),
                                      bussinessData.id.toString(),
                                      orders);
                                },
                                child: Text("Reject"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorManager.errorLight),
                              ),
                            ],
                          ));
                    }),
              ));
  }
}

Future<void> _showAcceptOrderDialog(
    BuildContext context,
    String title,
    String des,
    int index,
    bool isAccepting,
    String categoryId,
    String ShopId,
    List<OrderModel> orderModel) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(des),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.errorLight),
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.gradient2),
            child: Text("Conform"),
            onPressed: () {
              if (isAccepting) {
                context
                    .read<OrderController>()
                    .orderRequestConformation(
                        orderModel[index].id.toString(),
                        "Accepted",
                        index,
                        categoryId,
                        ShopId,
                        orderModel[index].amount!.toInt())
                    .then((value) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value)));
                });
              } else {
                context
                    .read<OrderController>()
                    .orderRequestConformation(
                        orderModel[index].id.toString(),
                        "Rejected",
                        index,
                        categoryId,
                        orderModel[index].shopid.toString(),
                        orderModel[index].amount!.toInt())
                    .then((value) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value)));
                });
              }
              // Place your code here to handle order acceptance
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

//  Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Container(
//               height: 40,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 209, 209, 209),
//               ),
//               child: Center(
//                 child: Text(
//                   "Order Amount: ${orders[index].amount.toString()}",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//           ),
