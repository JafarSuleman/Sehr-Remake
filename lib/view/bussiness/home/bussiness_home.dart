import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/components/bussinessDrawerComponent.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import 'package:sehr_remake/controller/order_controller.dart';
import 'package:sehr_remake/controller/user_controller.dart';
import 'package:sehr_remake/model/order_model.dart';
import 'package:sehr_remake/model/user_model.dart' as UserM;
import 'package:sehr_remake/utils/color_manager.dart';
import 'package:sehr_remake/utils/text_manager.dart';
import '../../../components/custom_card_widget.dart';
import '../../../components/loading_widget.dart';
import '../../../utils/app/constant.dart';
import '../../../utils/size_config.dart';

class BusinessHomeScreen extends StatefulWidget {
  final String identifier;
  BusinessHomeScreen({Key? key, required this.identifier}) : super(key: key);

  @override
  State<BusinessHomeScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  String email = "";
  String phone = "";
  Timer? _orderTimer; // Timer for periodic order fetching
  bool isInitialLoading = true; // Flag for initial loading
  List<UserM.User?>? users; // Holds user data

  @override
  void initState() {
    super.initState();

    // Initial Fetch
    print("Initial isInitialLoading: $isInitialLoading");
    context.read<BussinessController>().getBussinessData(widget.identifier).then((value) {
      if (!mounted) return;

      var bussinessData = context.read<BussinessController>().singleShopData;

      print("Fetched Business Data: ${bussinessData.toJson()}");

      // Fetch Orders
      context.read<OrderController>().getShopOrders(bussinessData.id.toString()).then((_) {
        print("Fetched Orders: ${context.read<OrderController>().shopOrders.map((e) => e.toJson())}");

        // Fetch User Data
        context.read<UserController>().getSelectedUser(context.read<OrderController>().shopOrders).then((fetchedUsers) {
          print("Fetched Users: ${fetchedUsers?.map((e) => e?.toJson())}");
          setState(() {
            users = fetchedUsers;
            isInitialLoading = false;
          });


          _orderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
            if (!mounted) {
              timer.cancel();
              return;
            }
            print("Fetching periodic orders...");
            context.read<OrderController>().getShopOrders(bussinessData.id.toString()).then((_) {
              context.read<UserController>().getSelectedUser(context.read<OrderController>().shopOrders).then((fetchedUsers) {
                setState(() {
                  users = fetchedUsers;

                });
              }).catchError((error) {
                print("Error fetching periodic user data: $error");
              });
            }).catchError((error) {
              print("Error fetching periodic orders: $error");
            });
          });
        }).catchError((error) {
          print("Error fetching user data: $error");
          setState(() {
            users = [];
            isInitialLoading = false;
          });
        });
      }).catchError((error) {
        print("Error fetching orders: $error");
        setState(() {
          isInitialLoading = false;
        });
      });
    }).catchError((error) {
      print("Error fetching business data: $error");
      setState(() {
        isInitialLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _orderTimer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var businessData = context.watch<BussinessController>().singleShopData;
    List<OrderModel> orders = context.watch<OrderController>().shopOrders;

    phone = businessData?.mobile != null && businessData.mobile != "null" && businessData.mobile!.isNotEmpty
        ? businessData.mobile.toString()
        : "";

    email = businessData?.email != null && businessData.email != "null" && businessData.email!.isNotEmpty
        ? businessData.email.toString()
        : "";

    print("Business Mobile ==> $phone");
    print("Business email ==> $email");
    print("Orders List Length: ${orders.length}");
    print("Users List Length: ${users?.length}");

    return Scaffold(
      drawer: BussinessDrawer(
        name: businessData?.businessName?.toString() ?? "",
        emailOrPhone: email.isNotEmpty ? email : phone,
        imgUrl: businessData?.logo?.toString() ?? "",
      ),
      appBar: AppBar(
        backgroundColor: ColorManager.gradient2,
        title: const Text("Your Orders"),
      ),
      body:isInitialLoading
          ? Center(
        child: loadingSpinkit(ColorManager.gradient1, 50),
      )
          : orders.isEmpty
          ? Center(
        child: Text(
          "No Orders Yet!",
          style: TextStyleManager.mediumTextStyle(
            color: ColorManager.textGrey,
            fontSize: 16,
          ),
        ),
      )
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          int reversedIndex = orders.length - 1 - index;
          OrderModel order = orders[reversedIndex];
          UserM.User? user = users != null && users!.length > reversedIndex
              ? users![reversedIndex]
              : null;

          if (user == null) {
            return const ListTile(
              title: Text('User data not available'),
            );
          }

          return CustomListTileWidget(
            leading: SizedBox(
              height: getProportionateScreenHeight(60),
              width: getProportionateScreenWidth(60),
              child: Image.network(
                "${Constants.BASE_URL}/${user.avatar.toString()}",
                fit: BoxFit.cover,
                errorBuilder: (context, e, stackTrace) => Image.network(
                  "https://www.nicepng.com/png/detail/933-9332131_profile-picture-default-png.png",
                  fit: BoxFit.fill,
                ),
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kTextBentonSansMed(
                  user.firstName?.toString() ?? 'No Name',
                  fontSize: getProportionateScreenHeight(15),
                  overFlow: TextOverflow.ellipsis,
                ),
                kTextBentonSansReg(
                  DateFormat("yyyy-MM-dd").format(DateTime.parse(order.date.toString())).toString(),
                  color: ColorManager.textGrey.withOpacity(0.8),
                  letterSpacing: getProportionateScreenWidth(0.5),
                ),
                kTextBentonSansMed(
                  'RS ${order.amount}',
                  color: ColorManager.primary,
                  fontSize: getProportionateScreenHeight(16),
                ),
              ],
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAcceptOrderDialog(
                      context,
                      "Confirm Acceptance",
                      "Are you sure you want to accept this order of Rs ${order.amount}?",
                      reversedIndex,
                      true,
                      businessData.categoryId.toString(),
                      businessData.id.toString(),
                      orders,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.gradient2,
                  ),
                  child: const Text(
                    "Accept",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAcceptOrderDialog(
                      context,
                      "Confirm Rejection",
                      "Are you sure you want to reject this order of Rs ${order.amount}?",
                      reversedIndex,
                      false,
                      businessData.categoryId.toString(),
                      businessData.id.toString(),
                      orders,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.errorLight,
                  ),
                  child: const Text(
                    "Reject",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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
                backgroundColor: ColorManager.errorLight,
              ),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.gradient2,
              ),
              child: const Text("Confirm"),
              onPressed: () {
                if (isAccepting) {
                  context.read<OrderController>().orderRequestConformation(
                    orderModel[index].id.toString(),
                    "Accepted",
                    index,
                    categoryId,
                    ShopId,
                    orderModel[index].amount!.toInt(),
                  ).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(value)),
                    );
                  });
                } else {
                  context.read<OrderController>().orderRequestConformation(
                    orderModel[index].id.toString(),
                    "Rejected",
                    index,
                    categoryId,
                    orderModel[index].shopid.toString(),
                    orderModel[index].amount!.toInt(),
                  ).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(value)),
                    );
                  });
                }
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
