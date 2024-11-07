import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/commission_Controller.dart';
import 'package:sehr_remake/controller/order_controller.dart';
import 'package:sehr_remake/utils/color_manager.dart';
import 'package:sehr_remake/utils/text_manager.dart';
import 'package:sehr_remake/view/bussiness/pay_commission.dart';

import '../../../controller/bussinesController.dart';

class BussinessReport extends StatefulWidget {
  const BussinessReport({super.key});

  @override
  State<BussinessReport> createState() => _BussinessReportState();
}

class _BussinessReportState extends State<BussinessReport> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var bussinessData = context.read<BussinessController>().singleShopData;
    print(bussinessData.id);
    context
        .read<OrderController>()
        .getTotalShopOrders(bussinessData.id.toString());
    context
        .read<CommissionController>()
        .getCommissionAndSaleDetail(bussinessData.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    var commission = context.watch<CommissionController>().commission;
    var orders = context.watch<OrderController>().totalOrders;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.gradient2,
        title: Text("Reports"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: ColorManager.gradient2,
                    borderRadius: BorderRadius.circular(15)),
                height: 140,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Sale",
                      style: TextStyleManager.boldTextStyle(
                          fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Rs ${commission.totalSale}",
                      style: TextStyleManager.boldTextStyle(
                          fontSize: 18, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: ColorManager.errorLight,
                    borderRadius: BorderRadius.circular(15)),
                height: 160,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "UnPaid Commission",
                      style: TextStyleManager.boldTextStyle(
                          fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Rs ${commission.commission}",
                      style: TextStyleManager.boldTextStyle(
                          fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.gradient2),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PayScreen(),
                              ));
                        },
                        child: const Text("Pay"))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 136, 167, 22),
                    borderRadius: BorderRadius.circular(15)),
                height: 160,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Orders Completed",
                      style: TextStyleManager.boldTextStyle(
                          fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      orders.toString(),
                      style: TextStyleManager.boldTextStyle(
                          fontSize: 18, color: Colors.white),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: ColorManager.error),
                    //     onPressed: () {},
                    //     child: const Text("Pay"))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
