import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehr_remake/view/bussiness/home/bussiness_report.dart';
import 'package:sehr_remake/view/bussiness/profile/edit_bussiness_profile.dart';
import '../utils/app/constant.dart';
import '../utils/auth_check/auth_check.dart';
import '../utils/color_manager.dart';
import '../utils/text_manager.dart';
import '../view/contactus.dart';

class BussinessDrawer extends StatelessWidget {
  final String name;
  final String imgUrl;
  final String phone;
  const BussinessDrawer(
      {super.key,
      required this.name,
      required this.phone,
      required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: ColorManager.gradient1),
            accountName: Text(
              name,
              style: TextStyleManager.mediumTextStyle(),
            ),
            accountEmail: Text(
              phone,
              style: TextStyleManager.mediumTextStyle(),
            ),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: "${Constants.BASE_URL}/$imgUrl",
                  placeholder: (context, url) =>
                      Image.asset(SEHR_SHOP_ICON, fit: BoxFit.fill),
                  errorWidget: (context, url, error) {
                    return Image.asset(SEHR_SHOP_ICON, fit: BoxFit.fill);
                  }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              "Reports",
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BussinessReport(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditBussinessProfile(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.contacts),
            title: Text("Contact Us"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsPage(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthCheck(),
                    ));
              });
            },
          ),
          GestureDetector(
            onTap: () async => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthCheck(),
                )),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorManager.gradient2,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Text(
                "Switch To User",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
