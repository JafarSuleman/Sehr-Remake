import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/package_controller.dart';
import 'package:sehr_remake/controller/user_controller.dart';
import 'package:sehr_remake/model/business_model.dart';
import 'package:http/http.dart' as http;
import 'package:sehr_remake/model/user_model.dart';
import 'package:sehr_remake/utils/app/constant.dart';
import 'package:sehr_remake/utils/auth_check/bussiness_data_check.dart';
import '../../../../components/package_item_component.dart';
import '../../../../controller/bussinesController.dart';
import '../../../../utils/color_manager.dart';

class BussinessPackageScreen extends StatefulWidget {
  final XFile imgFile;
  final BussinessModel bussinessModel;

  BussinessPackageScreen(
      {super.key, required this.imgFile, required this.bussinessModel});

  @override
  State<BussinessPackageScreen> createState() => _BussinessPackageScreenState();
}

class _BussinessPackageScreenState extends State<BussinessPackageScreen> {
  List<String> includedIds = [
    "653e1e979818104d6fc5798b",
    "653e1c4c9818104d6fc57988",
    "653e1c4c9818104d6fc57981",
    "653e1c4c9818104d6fc57980",
    "653e1c4c9818104d6fc5797f",
  ];

  List<String> excludedIds = [
    "653e1c4c9818104d6fc5797e",
    "653e1c4c9818104d6fc57982",
    "653e1c4c9818104d6fc57983",
    "653e1c4c9818104d6fc57987",
    "653e1d549818104d6fc57989",
    "653e1dd29818104d6fc5798a",
    "653e1e979818104d6fc5798b",
  ];

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserController>().userModel;
    var packages = context.watch<PackageController>().packages;

    packages = packages
        .where((package) =>
            includedIds.contains(package.id) &&
            !excludedIds.contains(package.id))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text("Sehr Packages"),
          backgroundColor: ColorManager.gradient1,
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: packages.length,
              itemBuilder: (context, index) => PackageItem(
                title: packages[index].title.toString(),
                description: packages[index].description.toString(),
                pressed: () async {
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    String res = await BussinessController()
                        .createBussinessData(
                            widget.bussinessModel, widget.imgFile);
                    print(packages[index].id);
                    var response = await http.put(
                        Uri.parse(
                            "${Constants.BASE_URL}/api/v1/user/package/${user.mobile!}"),
                        body: {"package": packages[index].id});
                    print(response.body);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckForBussinesData(),
                        ));
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    print(e);
                  }
                },
              ),
            ),
            if (isLoading)
              Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
          ],
        ));
  }
}
// localhost:3505