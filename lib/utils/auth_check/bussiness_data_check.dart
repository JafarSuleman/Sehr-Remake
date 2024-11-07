import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import 'package:sehr_remake/view/bussiness/home/bussiness_home.dart';
import 'package:sehr_remake/view/bussiness/home/registeration/bussiness_registeration_view.dart';

import '../../controller/user_controller.dart';

import '../../view/collecting_user_data/customer_bio.dart';
import '../../view/home/home.dart';

class CheckForBussinesData extends StatelessWidget {
  const CheckForBussinesData({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BussinessController().checkForBussinessData(
          FirebaseAuth.instance.currentUser!.phoneNumber.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              print("homscreen");
              return BusinessHomeScreen();
            } else {
              return AddBusinessDetailsView();
            }
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Text(snapshot.error.toString()),
            );
          }
        }
        return Scaffold(
          body: Text("Check Your internetConnection"),
        );
      },
    );
  }
}
