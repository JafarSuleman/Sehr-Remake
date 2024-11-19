import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../view/auth/login.dart';
import 'data_check.dart';

class AuthCheck extends StatefulWidget {
  bool? isFromSpecialPackage =false;
  String? specialPackageName;
  String? specialPackageNameFromOtp;
  String? selectedLocationIdFromOtp;
  String? selectedLocationId;
  bool? isFromLogout = false;
  String? phone;
  String? whatsApp;
  String? email;
   AuthCheck({super.key,this.email,this.phone,this.isFromSpecialPackage,this.specialPackageName,this.specialPackageNameFromOtp,this.selectedLocationId,this.selectedLocationIdFromOtp,this.isFromLogout,this.whatsApp});
  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool isAuthenticated = false;
  String? phone;
  String? whatsApp;
  String? email;
  String? isIdentifierAvailable;
  String? isAuthMethodAvailable;

  @override
  void initState() {
    super.initState();

    if (widget.isFromLogout == true) {
      widget.email = null;
      widget.specialPackageName = null;
      widget.specialPackageNameFromOtp= null;
      widget.selectedLocationIdFromOtp= null;
    }

    checkAuthentication();
    print("Auth Screen Special Package ==> ${widget.isFromSpecialPackage}");
    print("Auth Screen Email ==> ${widget.email}");
    print("Auth Screen whatsApp ==> ${widget.whatsApp}");
    print("Auth Screen Special Package Id ==> ${widget.specialPackageName}");
    print("Auth Screen Is From Logout ==> ${widget.isFromLogout}");
    print("Auth Screen Special Package Id From Otp Screen ==> ${widget.specialPackageNameFromOtp}");
  }

  Future<void> checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPhoneAuthenticated = FirebaseAuth.instance.currentUser != null;
    bool isWhatsAppAuthenticated = prefs.getBool('isWhatsAppAuthenticated') ?? false;
    bool isEmailAuthenticated = prefs.getBool('isEmailAuthenticated') ?? false;
    String authMethod = prefs.getString('authMethod') ?? '';
    String identifier = prefs.getString('identifier') ?? '';

    setState(() {
      isAuthMethodAvailable = authMethod;
      isIdentifierAvailable = identifier;
      print("Auth Screen Auth Method ==> $isAuthMethodAvailable");
      print("Auth Screen Identifier ==> $isIdentifierAvailable");

      if(authMethod=="email"){
        widget.email = identifier;
      }

      if(authMethod=="whatsApp"){
        widget.whatsApp = identifier;
      }

      isAuthenticated = isPhoneAuthenticated || isEmailAuthenticated || isWhatsAppAuthenticated;
      if (isPhoneAuthenticated) {
        phone = FirebaseAuth.instance.currentUser!.phoneNumber;
        prefs.setString('authMethod', 'phone');
        prefs.setString('identifier', phone!);
      }

      if (isWhatsAppAuthenticated) {
        phone = prefs.getString('whatsApp');
        prefs.setString('authMethod', 'phone');
        prefs.setString('identifier', phone!);
      }

      if (isEmailAuthenticated) {
        email = prefs.getString('email');
        prefs.setString('authMethod', 'email');
        prefs.setString('identifier', email!);
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    if (!isAuthenticated) {
      return LoginView(
        isFromSpecialPackage: widget.isFromSpecialPackage,
        specialPackageName: widget.specialPackageName,
        selectedLocationId: widget.selectedLocationId,
        isFromLogout: widget.isFromLogout,
      );
    } else {
      return  CheckForData(email: widget.email,specialPackageNameFromOtp: widget.specialPackageNameFromOtp,selectedLocationIdFromOtp: widget.selectedLocationIdFromOtp,isFromLogout: widget.isFromLogout,);
    }
  }
}






// class AuthCheck extends StatefulWidget {
//   @override
//   State<AuthCheck> createState() => _AuthCheckState();
// }
//
// class _AuthCheckState extends State<AuthCheck> {
//   bool isAuthenticated = false;
//   String? phone;
//   String? email;
//
//   @override
//   void initState() {
//     super.initState();
//     checkAuthentication();
//   }
//
//   Future<void> checkAuthentication() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isPhoneAuthenticated = FirebaseAuth.instance.currentUser != null;
//     bool isEmailAuthenticated = prefs.getBool('isEmailAuthenticated') ?? false;
//
//     setState(() {
//       isAuthenticated = isPhoneAuthenticated || isEmailAuthenticated;
//       if (isPhoneAuthenticated) {
//         phone = FirebaseAuth.instance.currentUser!.phoneNumber;
//       }
//       if (isEmailAuthenticated) {
//         email = prefs.getString('email');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!isAuthenticated) {
//       return LoginView();
//     } else {
//       if (phone != null) {
//         return CheckForData(mobile: phone!);
//       } else if (email != null) {
//         return CheckForData(email: email!);
//       } else {
//         return LoginView();
//       }
//     }
//   }
// }


// class AuthCheck extends StatefulWidget {
//   @override
//   State<AuthCheck> createState() => _AuthCheckState();
// }
//
// class _AuthCheckState extends State<AuthCheck> {
//   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: firebaseAuth.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.data != null) {
//           print("Auth checking : ${snapshot.data!.uid}");
//           return CheckForData(
//               mobile:
//                   FirebaseAuth.instance.currentUser!.phoneNumber.toString());
//         } else {
//           return LoginView();
//         }
//       },
//     );
//   }
// }
