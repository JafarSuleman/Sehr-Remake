import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import 'package:sehr_remake/controller/category_controller.dart';
import 'package:sehr_remake/controller/commission_Controller.dart';
import 'package:sehr_remake/controller/order_controller.dart';
import 'package:sehr_remake/controller/package_controller.dart';
import 'package:sehr_remake/controller/user_controller.dart';
import 'controller/special_package_controller.dart';
import 'firebase_options.dart';
import 'utils/routes/routes.dart';
import 'utils/size_config.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(SpecialPackageController());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  getAppSignature();
  //FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  runApp(const MyApp(),);

  // runApp(DevicePreview(
  //   enabled: !kReleaseMode,
  //   builder: (context) => const MyApp(),));
}


void getAppSignature() async {
  String appSignature = await SmsAutoFill().getAppSignature;
  print("App Signature: $appSignature");
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),

      // WidgetsFlutterBinding.ensureInitialized();
      // SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.portraitUp,
      //   DeviceOrientation.portraitDown,
      // ]);
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BussinessController(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderController(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserController(),
        ),
        ChangeNotifierProvider(
          create: (context) => PackageController(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryController(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommissionController(),
        ),
        //ChangeNotifierProvider(create: (_) => UserTableController()),
      ],
      child: GetMaterialApp(
        //home: HomeScreen(),
        builder: (context, child) {
          SizeConfig().init(context);
          return Theme(data: ThemeData(), child: child!);
        },

       debugShowCheckedModeBanner: false,
        //theme: getAppTheme(context),
        onGenerateRoute: RoutesGenerator.getRoute,
        initialRoute: Routes.splashRoute,
        //initialRoute: Routes.bottomNavigationRoute,
      ),
    );
  }
}
