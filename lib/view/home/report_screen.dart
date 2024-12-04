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
import '../../model/package_model.dart';
import '../../utils/app/constant.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';



class ReportScreen extends StatefulWidget {
  String? userId ;

  ReportScreen({super.key ,required this.userId});

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
    print("User UserId ==> ${widget.userId}");
    context.read<OrderController>().getUserOrderModel(
        widget.userId);
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
    return [];
  }
  List<OrderModel> getWeeklyData(List<OrderModel> orders) {
    return [];
  }
  List<OrderModel> getMonthlyData(List<OrderModel> orders) {
    return [];
  }
  List<OrderModel> getYearlyData(List<OrderModel> orders) {
    return [];
  }
  @override
  Widget build(BuildContext context) {
    List<OrderModel> orders = context.watch<OrderController>().userOrders;
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


    var packages = context.watch<PackageController>().packages;
    var userData = context.watch<UserController>().userModel;
    PackageModel? activatedPackage;
    final dummyPackage = PackageModel(id: '', title: '', description: '', salesTarget: 0); // Adjust based on PackageModel

    if (userData.package != null) {
      // Regular package
      activatedPackage = packages.firstWhere(
            (element) => element.id == userData.package,
        orElse: () => dummyPackage,
      );
    } else if (userData.specialPackage != null) {
      // Special package
      activatedPackage = packages.firstWhere(
            (element) => element.id == userData.specialPackage,
        orElse: () => dummyPackage,
      );
    }

    // Set activatedPackage to null if it matches dummyPackage
    if (activatedPackage == dummyPackage) {
      activatedPackage = null;
    }

    print('Activatd Package ==> ${activatedPackage?.id} + ${activatedPackage?.title} + ${activatedPackage?.description} + ${activatedPackage?.salesTarget} +');




    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade900,
                  Colors.green.shade500,
                  Colors.green.shade900,
                ],
              ),
            ),
            child: AppBar(
              title: const Text(
                'User Report',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              elevation: 4,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
          ),
        ),
      ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spendings',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        'Total: Rs ${getTotalSpendings(orders)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Target: Rs ${activatedPackage?.salesTarget ?? '0'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Progress',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: PieChart(
                          emptyColor: Colors.green.shade200,
                          dataMap: {"Target": getTotalSpendings(orders).toDouble()},
                          chartType: ChartType.disc,
                          baseChartColor: Colors.green.shade100,
                          colorList: [Colors.green.shade700],
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                          totalValue: activatedPackage?.salesTarget,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Orders",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: searchTypes.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSearchType = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 50,
                      width: 90,
                      decoration: BoxDecoration(
                        gradient: selectedSearchType == index
                            ? LinearGradient(
                                colors: [
                                  Colors.green.shade900,
                                  Colors.green.shade500,
                                ],
                              )
                            : null,
                        color: selectedSearchType != index ? Colors.white : null,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          searchTypes[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: selectedSearchType == index
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: BussinessController()
                    .getSelectedBussiness(orderToShow(selectedSearchType)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
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
    ));
  }
}

class SalesData {
  SalesData(this.month, this.amount);
  final String month;
  final double amount;
}