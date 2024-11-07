import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/order_controller.dart';
import 'package:sehr_remake/controller/package_controller.dart';
import 'package:sehr_remake/model/order_model.dart';
import 'package:sehr_remake/utils/text_manager.dart';
import '../../components/custom_card_widget.dart';
import '../../controller/bussinesController.dart';
import '../../controller/user_controller.dart';
import '../../utils/app/constant.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';



class ReportScreen extends StatefulWidget {
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<String> searchTypes = ["Today", "Weekly", "Monthly", "Yearly"];

  int selectedSearchType = 0;

  final dataMap = <String, double>{
    "Target": 200000,
  };

  final colorList = <Color>[
    Colors.greenAccent,
  ];

  @override
  void initState() {
    context.read<OrderController>().getUserOrderModel(
        FirebaseAuth.instance.currentUser!.phoneNumber.toString());
    super.initState();
  }
// Get the current date

  int getTotalSpendings(List<OrderModel> orders) {
    int spendings = 0;

    for (var i = 0; i < orders.length; i++) {
      if (orders[i].status == "Accepted") {
        spendings += orders[i].amount!.toInt();
      }
    }

    return spendings;
  }

  List<OrderModel> getTodayData(List<OrderModel> orders) {
    // Empty function for now
    return [];
  }

  List<OrderModel> getWeeklyData(List<OrderModel> orders) {
    // Empty function for now
    return [];
  }

  List<OrderModel> getMonthlyData(List<OrderModel> orders) {
    // Empty function for now
    return [];
  }

  List<OrderModel> getYearlyData(List<OrderModel> orders) {
    // Empty function for now
    return [];
  }


  @override
  Widget build(BuildContext context) {
    List<OrderModel> orders = context.watch<OrderController>().userOrders;

    var packages = context.watch<PackageController>().packages;
    var userData = context.watch<UserController>().userModel;
    var activatedPackage =
        packages.where((element) => element.id == userData.package).first;

    List<OrderModel> orderToShow(int selectedSearchType) {
      switch (selectedSearchType) {
        case 0:
          return getTodayData(orders);
        case 1:
          return getTodayData(orders);
        case 2:
          return getMonthlyData(orders);
        case 3:
          return getYearlyData(orders);
        default:
          return orders;
      }
    }



    return Scaffold(
      appBar: AppBar(
        title: Text('User Report'),
        backgroundColor: ColorManager.gradient1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Spendings',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Total:${getTotalSpendings(orders)}', // Replace with actual spending data
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Target: Rs ${activatedPackage.salesTarget}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Target Progress',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: PieChart(
                      emptyColor: Color.fromARGB(255, 176, 250, 103),
                      dataMap: {"Target": getTotalSpendings(orders).toDouble()},
                      chartType: ChartType.disc,
                      baseChartColor:
                          Color.fromARGB(255, 203, 248, 148)!.withOpacity(0.5),
                      colorList: colorList,
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValuesInPercentage: true,
                      ),
                      totalValue: activatedPackage.salesTarget,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Orders",
            style: TextStyleManager.boldTextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: searchTypes.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSearchType = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    height: 50,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorManager.textGrey),
                        borderRadius: BorderRadius.circular(15),
                        color: selectedSearchType == index
                            ? ColorManager.gradient2
                            : ColorManager.grey),
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        searchTypes[index],
                        style: TextStyleManager.regularTextStyle(
                            fontSize: 16,
                            color: selectedSearchType == index
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: FutureBuilder(
            future: BussinessController()
                .getSelectedBussiness(orderToShow(selectedSearchType)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return CustomListTileWidget(
                          leading: SizedBox(
                            height: getProportionateScreenHeight(60),
                            width: getProportionateScreenWidth(60),
                            child: Image.network(
                              "${Constants.BASE_URL}/${snapshot.data![index].logo.toString()}",
                              fit: BoxFit.cover,
                              errorBuilder: (context,
                                      e,
                                      // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                                      StackTrace) =>
                                  Image.asset(AppImages.menu),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              kTextBentonSansMed(
                                // filterlisttype[index]['name'],
                                snapshot.data![index].businessName.toString(),
                                fontSize: getProportionateScreenHeight(15),
                                overFlow: TextOverflow.ellipsis,
                              ),
                              // buildVerticleSpace(4),
                              kTextBentonSansReg(
                                DateFormat("yyyy-MM-dd")
                                    .format(DateTime.parse(
                                        orderToShow(selectedSearchType)[index]
                                            .date
                                            .toString()))
                                    .toString(),
                                // filterlisttype[index]["date"],
                                color: ColorManager.textGrey.withOpacity(0.8),
                                letterSpacing: getProportionateScreenWidth(0.5),
                              ),
                              // buildVerticleSpace(8),
                              kTextBentonSansMed(
                                'RS ${orderToShow(selectedSearchType)[index].amount}',
                                color: ColorManager.primary,
                                fontSize: getProportionateScreenHeight(16),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              orderToShow(selectedSearchType)[index]
                                  .status
                                  .toString(),
                              style: TextStyleManager.regularTextStyle(
                                  fontSize: 16),
                            ),
                          ));
                    });
              }
              return Center(
                child: Text(
                  "No Data Found",
                  style: TextStyleManager.regularTextStyle(fontSize: 16),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.month, this.amount);
  final String month;
  final double amount;
}
