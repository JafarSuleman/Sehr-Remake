import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import 'package:sehr_remake/utils/app/constant.dart';
import 'package:sehr_remake/utils/auth_check/bussiness_data_check.dart';
import 'package:sehr_remake/view/contactus.dart';
import 'package:sehr_remake/view/home/aboutus.dart';
import 'package:sehr_remake/view/profile/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/auth_check/auth_check.dart';
import '../utils/color_manager.dart';
import '../utils/text_manager.dart';

class DrawerComponent extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String phone;
  const DrawerComponent({
    super.key,
    required this.name,
    required this.phone,
    required this.imgUrl,
  });

  Future<void> _handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authMethod = prefs.getString('authMethod') ?? '';

    if (authMethod == 'phone') {
      // Firebase logout for phone authentication
      await FirebaseAuth.instance.signOut();
      // Remove phone number from SharedPreferences
      await prefs.clear();
    } else if (authMethod == 'email') {
      // Remove email from SharedPreferences
      await prefs.clear();
    }

    // Navigate to AuthCheck screen after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AuthCheck(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: ColorManager.gradient1),
            accountName: Text(
              name,
              style: TextStyleManager.mediumTextStyle(),
            ),
            accountEmail: Text(
              phone.replaceFirst("+92", "0"),
              style: TextStyleManager.mediumTextStyle(),
            ),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: "${Constants.BASE_URL}/$imgUrl",
                placeholder: (context, url) =>
                    Image.asset(SEHR_SHOP_ICON, fit: BoxFit.fill),
                errorWidget: (context, url, error) =>
                    Image.asset(SEHR_SHOP_ICON, fit: BoxFit.fill),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("About Us"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(key: key),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text("Contact Us"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactUsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => _handleLogout(context),
          ),
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CheckForBussinesData(),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorManager.gradient2,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: const Text(
                "Switch To Bussiness",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
