import 'package:flutter/material.dart';

import '../../view/auth/login.dart';
import '../../view/auth/signup.dart';

import '../../view/collecting_user_data/customer_bio.dart';
import '../../view/home/alerts_screen.dart';
import '../../view/home/home.dart';
import '../../view/home/package_screen.dart';
import '../../view/home/report_screen.dart';
import '../../view/home/shop/shop_detail_view.dart';
import '../../view/home/shop_screen.dart';
import '../../view/onboarding/onboarding.dart';

import '../../view/profile/customer_bio.dart';
import '../../view/profile/customer_photo.dart';
import '../../view/profile/phone_otp_screen.dart';
import '../../view/splash/splash.dart';
import '../string_manager.dart';

class Routes {
  static const String homeRoute = '/homeRoute';
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';

  // Auth views
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signUp';
  // static const String profileSelectionRoute = '/profileSelection';
  static const String alertRoute = '/alertRoute';
  static const String package_screenRoute = '/packageScreenRoute';

  static const String reportRoute = '/reportRoute';

  static const String shopviewRoute = '/shopviewRoute';
  static const String shopdetailRoute = '/shopdetailRoute';

  // Profile views
//  static const String addCustomerBioRoute = '/addCustomerBio';
  static const String addBusinessBioRoute = '/addBusinessBio';
  static const String photoSelectionRoute = '/photoSelection';
  static const String setLocationRoute = '/setLocation';
  static const String verificationCodeRoute = '/verificationCode';
  static const String profileCompleteRoute = '/profileComplete';
  static const String businessVerificationRoute = '/businessVerification';
  static const String businessVerificationProcesingRoute =
      '/businessVerificationProcessing';
  static const String qrBusinessRoute = '/qrBusiness';

  // Customer Side Views
  static const String drawerRoute = '/drawer';
  static const String customerBottomNavRoute = '/customerBottomNav';
  static const String scannerRoute = '/scanner';
  static const String paymentRoute = '/payment';
}

class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      // Auth Routes
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginView());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpView());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Routes.alertRoute:
        return MaterialPageRoute(builder: (_) => AlertScreen());
      case Routes.package_screenRoute:
        return MaterialPageRoute(builder: (_) => PackageScreen());
      case Routes.reportRoute:
        return MaterialPageRoute(builder: (_) => ReportScreen(userId: '',));
      case Routes.shopviewRoute:
        return MaterialPageRoute(builder: (_) => ShopViewScreen());
      // case Routes.shopdetailRoute:
      //   return MaterialPageRoute(builder: (_) => ShopDetailsView());

      // // Profile Routes
      // case Routes.addCustomerBioRoute:
      //   return MaterialPageRoute(builder: (_) => const AddCustomerBioView());
      // case Routes.addBusinessBioRoute:
      //   return MaterialPageRoute(
      //       builder: (_) => const AddBusinessDetailsView());
      case Routes.photoSelectionRoute:
        return MaterialPageRoute(
            builder: (_) => const UplaodProfilePhotoView());
      // case Routes.setLocationRoute:
      //   // Map<String, dynamic> arguments =
      //   //     routeSettings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (_) => const SetLocationView(
      //         // imageFile: arguments['image'],
      //         ),
      //   );
      // case Routes.verificationCodeRoute:
      //   return MaterialPageRoute(builder: (_) => const VerificationCodeView());
      // case Routes.profileCompleteRoute:
      //   return MaterialPageRoute(builder: (_) => const ProfileCompleteView());

      // // Customer Side Views
      // case Routes.drawerRoute:
      //   return MaterialPageRoute(
      //       builder: (_) => DrawerView(
      //             pageindex: 0,
      //           ));
      // case Routes.customerBottomNavRoute:
      //   return MaterialPageRoute(
      //       builder: (_) => BottomNavigationView(
      //             pageindexview: 0,
      //           ));
      // case Routes.scannerRoute:
      //   return MaterialPageRoute(builder: (_) => const ScannerView());

      // // Business Side Views
      // case Routes.businessVerificationRoute:
      //   return MaterialPageRoute(
      //       builder: (_) => const BusinessVerificationView());
      // case Routes.businessVerificationProcesingRoute:
      //   return MaterialPageRoute(
      //       builder: (_) => const BusinessVerificationProcessingView());
      // case Routes.qrBusinessRoute:
      //   return MaterialPageRoute(builder: (_) => const QrBusinessView());
      // case Routes.paymentRoute:
      //   return MaterialPageRoute(
      //       builder: (_) => PaymentView(
      //             datetime: "",
      //             amount: "",
      //           ));
    }
    return _unDefinedRoute();
  }

  static Route<dynamic> _unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(StringManager.undefinedRoute),
        ),
        body: const Center(
          child: Text(StringManager.noRouteFound),
        ),
      ),
    );
  }
}
