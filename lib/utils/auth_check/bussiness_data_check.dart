import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import 'package:sehr_remake/view/bussiness/home/bussiness_home.dart';
import 'package:sehr_remake/view/bussiness/home/registeration/bussiness_registeration_view.dart';

import '../../components/loading_widget.dart';
import '../../controller/user_controller.dart';

import '../../view/collecting_user_data/customer_bio.dart';
import '../../view/home/home.dart';
import '../color_manager.dart';

class CheckForBusinessData extends StatelessWidget {
  String? identifier;
   CheckForBusinessData({super.key,required this.identifier});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BussinessController().checkForBusinessData(
          identifier!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: loadingSpinkit(ColorManager.gradient1, 80)),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              print("homscreen");
              return BusinessHomeScreen(identifier: identifier??"",);
            } else {
              return AddBusinessDetailsView(identifier: identifier,);
            }
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Text(snapshot.error.toString()),
            );
          }
        }
        return const Scaffold(
          body: Text("Check Your internetConnection"),
        );
      },
    );
  }
}
