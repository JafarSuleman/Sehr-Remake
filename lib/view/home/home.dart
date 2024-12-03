import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import 'package:sehr_remake/controller/user_controller.dart';
import 'package:sehr_remake/model/business_model.dart';
import 'package:sehr_remake/utils/app/constant.dart';
import 'package:sehr_remake/view/home/report_screen.dart';
import 'package:sehr_remake/view/home/shop/shop_detail_view.dart';
import 'package:sehr_remake/view/home/shop_screen.dart';
import 'package:sehr_remake/view/home/silver_appbar_delicate.dart';
import 'package:sehr_remake/view/home/special_package_screen/selected_special_package_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/drawer_component.dart';
import '../../components/home_button_component.dart';
import '../../components/loading_widget.dart';
import '../../components/special_Package_Info_Dialog.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/text_manager.dart';
import '../../utils/values_manager.dart';
import '../bussiness/home/registeration/bussiness_registeration_view.dart';
import 'alerts_screen.dart';
import 'selected_package.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Position? position;
  String? _currentLocationName;
  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey();
  late AnimationController _blinkAnimationController;
  late Animation<double> _bounceAnimation;
  late AnimationController _bounceAnimationController;
  bool _isLoading = true;
  bool showBlinking = true;
  String? identifier;

  late Animation<double> _blinkAnimation;
  Timer? _bounceTimer;

  Future<void> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      try {
        final location = await getCurrentLocation();
        setState(() {
          position = location;
        });
        _getLocationName(location);
      } catch (e) {
        print("Error fetching location: $e");
      }
    } else if (status.isDenied) {
      print("Location permission denied");
      // Handle UI updates when permission is denied
    } else if (status.isPermanentlyDenied) {
      print("Location permission permanently denied. Opening settings...");
      openAppSettings();
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers

    // Convert latitude and longitude from degrees to radians
    final double lat1Rad = radians(lat1);
    final double lon1Rad = radians(lon1);
    final double lat2Rad = radians(lat2);
    final double lon2Rad = radians(lon2);

    // Haversine formula
    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;
    final double a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    return distance; // Distance in kilometers
  }

  double calculateDistance1(
      BussinessModel shop, double userLat, double userLon) {
    const double earthRadius = 6371.0; // Radius of the Earth in kilometers

    double lat1 = userLat * pi / 180.0;
    double lon1 = userLon * pi / 180.0;
    double lat2 = shop.lat! * pi / 180.0;
    double lon2 = shop.lon! * pi / 180.0;

    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;

    double a = sin(dlat / 2) * sin(dlat / 2) +
        cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double radians(double degrees) {
    return degrees * pi / 180;
  }

  Future<Position> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error in getCurrentLocation: $e");
      rethrow;
    }
  }

  // List<BussinessModel> filterNearbyShops(
  //     List<BussinessModel> allShops, Position userLocation, double radiusInKm) {
  //   // List<BussinessModel> nearbyShops = [];

  //   // for (var shop in allShops) {
  //   //   double distance = Geolocator.distanceBetween(
  //   //     userLocation.latitude,
  //   //     userLocation.longitude,
  //   //     shop.lat as double,
  //   //     shop.lon as double,
  //   //   );

  //   //   if (distance / 1000 <= radiusInKm) {
  //   //     nearbyShops.add(shop);
  //   //   }
  //   // }

  // }

  List<BussinessModel> sortShopsByDistance(
      List<BussinessModel> allShops, Position userLocation) {
    allShops.sort((a, b) {
      double distanceToA = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        a.lat as double,
        a.lon as double,
      );

      double distanceToB = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        b.lat as double,
        b.lon as double,
      );

      return distanceToA.compareTo(distanceToB);
    });

    return allShops;
  }

  @override
  void initState() {
    super.initState();
    _bounceAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _bounceAnimationController,
        curve: Curves.decelerate,
      ),
    );
    _bounceAnimationController.repeat(reverse: true);
    
    getIdentifier();

    requestLocation();

    _initializeData();

    _blinkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    if (showBlinking) {
      _blinkAnimationController.repeat(reverse: true);
    }

    context.read<BussinessController>().getBussinesss();

    // Setup bounce animation
    _bounceAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: 8.0,
    ).animate(
      CurvedAnimation(
        parent: _bounceAnimationController,
        curve: Curves.decelerate,
      ),
    );

    // Start initial bounce animation
    performDoubleBounce();

    // Setup periodic bounce
    _bounceTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      performDoubleBounce();
    });

    // Existing animation setup
    _blinkAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  Future<void> requestLocation() async {
    await requestLocationPermission();
  }

  Future<void> getIdentifier() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    identifier = prefs.getString('identifier') ?? '';
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String identifier = prefs.getString('identifier') ?? '';
    await context.read<UserController>().getUserData(identifier, context);

    // Set loading to false once data is fetched
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getLocationName(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        final locationName =
            '${placemark.locality}, ${placemark.administrativeArea}';
        setState(() {
          _currentLocationName = locationName;
        });
      }
    } catch (e) {
      print('Error fetching location name: $e');
    }
  }

  @override
  void dispose() {
    _bounceAnimationController.dispose();
    _blinkAnimationController.dispose();
    _bounceTimer?.cancel();
    super.dispose();
  }

  void performDoubleBounce() {
    if (!mounted) return;
    
    _bounceAnimationController.forward().then((_) {
      if (!mounted) return;
      _bounceAnimationController.reverse().then((_) {
        if (!mounted) return;
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) return;
          _bounceAnimationController.forward().then((_) {
            if (!mounted) return;
            _bounceAnimationController.reverse();
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Get Identifier ==> $identifier");
    if (_isLoading) {
      return Scaffold(
        body: Center(child: loadingSpinkit(ColorManager.gradient1, 80)),
      );
    }
    return Consumer<UserController>(builder: (context, userController, child) {
      var userProvider = context.watch<UserController>().userModel;

      print(userProvider.firstName);
      print("Special Package ==> ${userProvider.specialPackage}");
      print("Package ==> ${userProvider.package}");

      if (userProvider.package == "653e1c4c9818104d6fc5797f" ||
          userProvider.package == "653e1c4c9818104d6fc57980" ||
          userProvider.package == "653e1c4c9818104d6fc57981" ||
          userProvider.package == "653e1c4c9818104d6fc57988" ||
          userProvider.package == "653e1e979818104d6fc5798b") {
        context
            .watch<BussinessController>()
            .checkForBusinessData(identifier!)
            .then((value) {
          if (value == true) {
            return;
          }
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddBusinessDetailsView(
                        identifier: identifier,
                      )));
        });
      }
      var business = context.watch<BussinessController>().bussinessModel;
      var deviceSize = MediaQuery.of(context).size;
      if (position != null) {
        business.sort((a, b) =>
            calculateDistance1(a, position!.latitude, position!.longitude)
                .compareTo(calculateDistance1(
                    b, position!.latitude, position!.longitude)));
      }

      print("User Name ==> ${userProvider.firstName} ${userProvider.lastName}");

      return Scaffold(
        key: _scafoldKey,
        drawer: DrawerComponent(
          name: "${userProvider.firstName} ${userProvider.lastName}",
          phone: userProvider.email != null
              ? userProvider.email.toString()
              : userProvider.mobile.toString(),
          imgUrl: userProvider.avatar.toString(),
          identifier: identifier.toString(),
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
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: kToolbarHeight + AppMargin.m10 * 2,
                    maxHeight: kToolbarHeight + AppMargin.m10 * 2.5,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green.shade50.withOpacity(0.9),
                            Colors.white.withOpacity(0.9),
                            Colors.green.shade50.withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            offset: const Offset(-4, -4),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppMargin.m10),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.1),
                                        offset: const Offset(0, 2),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.horizontal_split_sharp,
                                    color: ColorManager.gradient1,
                                    size: 25,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Welcome ${userProvider.firstName} ${userProvider.lastName}",
                                      style: TextStyleManager.mediumTextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    const SizedBox(height: AppMargin.m6),
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.green.withOpacity(0.1),
                                          ),
                                        ),
                                        child: Text(
                                          _currentLocationName == null
                                              ? "Loading Location..."
                                              : _currentLocationName!,
                                          style: TextStyleManager.lightTextStyle(
                                            fontSize: 11,
                                            textColor: Colors.green.shade800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.1),
                                        offset: const Offset(0, 2),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.notifications_active_outlined,
                                    size: 25,
                                    color: ColorManager.gradient2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Scrollable content
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppMargin.m10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: AppMargin.m16,
                        ),
                        //Banner Start
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.5),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 4),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    offset: const Offset(-4, -4),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),

                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.width / 2,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: FlutterCarousel(
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      autoPlayInterval: const Duration(seconds: 3),
                                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      disableCenter: true,
                                      viewportFraction: deviceSize.width > 800.0 ? 0.8 : 0.99,
                                      height: deviceSize.height * 0.45,
                                      enableInfiniteScroll: true,
                                      slideIndicator: CircularWaveSlideIndicator(
                                        slideIndicatorOptions: SlideIndicatorOptions(
                                          indicatorBackgroundColor: Colors.green.withOpacity(0.8),
                                          itemSpacing: 20.0,
                                          indicatorRadius: 6.0,
                                          padding: const EdgeInsets.only(bottom: 2),
                                        ),
                                      ),
                                    ),
                                    items: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network(
                                            "${Constants.BASE_URL}/uploads/11.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network(
                                            "${Constants.BASE_URL}/uploads/22.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network(
                                            "${Constants.BASE_URL}/uploads/33.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppMargin.m17),
                        //Banner End
                        GestureDetector(
                          onTap: () {
                            if (userProvider.specialPackage != null &&
                                userProvider.specialPackage!.isNotEmpty) {
                              Get.to(() => SelectedSpecialPackageScreen(
                                    specialPackageId: userProvider.specialPackage,
                                  ));
                            } else {
                              specialPackageInfoDialog(
                                  context, userProvider.specialPackage);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                userProvider.specialPackage == null ||
                                        userProvider.specialPackage!.isEmpty
                                    ? AnimatedBuilder(
                                        animation: _bounceAnimation,
                                        builder: (context, child) {
                                          return Transform.translate(
                                            offset: Offset(0, -_bounceAnimation.value),
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(vertical: 15),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.red.shade600,
                                                    Colors.red.shade800,
                                                    Colors.red.shade900,
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.green.withOpacity(0.25),
                                                    spreadRadius: 1,
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    AppIcons.specialIcon,
                                                    height: 24,
                                                    width: 24,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Text(
                                                    "Special Package",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.red.shade600,
                                              Colors.red.shade800,
                                              Colors.red.shade900,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.green.withOpacity(0.25),
                                              spreadRadius: 1,
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppIcons.specialIcon,
                                              height: 24,
                                              width: 24,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              "Special Package",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppMargin.m14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(AlertScreen());
                              },
                              child: const HomeButtonComponent(
                                  name: "Alerts",
                                  iconData: Icons.notification_important_rounded),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectedPackageScreen(
                                        selectedSpecialId:
                                            userProvider.specialPackage,
                                      ),
                                    ));
                              },
                              child: const HomeButtonComponent(
                                  name: "Packages", iconData: Icons.local_offer),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: AppMargin.m14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(ReportScreen(
                                  userId: userProvider.id,
                                ));
                              },
                              child: const HomeButtonComponent(
                                  name: "Reports",
                                  iconData: Icons.history_edu_rounded),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(const ShopViewScreen());
                              },
                              child: const HomeButtonComponent(
                                  name: "Shops", iconData: Icons.store),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Shops Near You Section Title
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppMargin.m14, vertical: AppMargin.m20),
                    child: Text(
                      "Shops Near You",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Shops Near You Grid
                position != null && business != null
                    ? business.isEmpty
                        ? const SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: AppMargin.m10),
                              child: Text(
                                "No Shops Here!",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppMargin.m10),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 25,
                                crossAxisSpacing: 25,
                                mainAxisExtent: 220,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  List<BussinessModel> nearByShops = business;
                                  final shop = nearByShops[index];

                                  if (shop.lat == null || shop.lon == null) {
                                    return const SizedBox();
                                  }

                                  final distance = calculateDistance(
                                    position!.latitude,
                                    position!.longitude,
                                    shop.lat as double,
                                    shop.lon as double,
                                  );
                                  final formattedDistance = distance < 1
                                      ? '${(distance * 1000).toStringAsFixed(2)} meters away'
                                      : '${distance.toStringAsFixed(2)} km away';

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ShopDetailsView(
                                            model: shop,
                                            distance: formattedDistance,
                                            identifier: userProvider.id ?? "",
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.green.withOpacity(0.5),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            offset: const Offset(0, 4),
                                            blurRadius: 15,
                                            spreadRadius: 1,
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.5),
                                            offset: const Offset(-4, -4),
                                            blurRadius: 15,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Image Container
                                            ClipRRect(
                                              borderRadius: const BorderRadius.vertical(
                                                top: Radius.circular(10),
                                              ),
                                              child: Container(
                                                height: 140,
                                                width: double.infinity,
                                                color: Colors.grey[200],
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: "${Constants.BASE_URL}/${shop.logo.toString()}",
                                                  placeholder: (context, url) => Image.network(
                                                    "https://media.istockphoto.com/id/913241794/vector/green-store-flat-design-environmental-icon.jpg?s=612x612&w=0&k=20&c=aBl5y54IVOQU__JocerMWJHTEsa3PBR1eZyBlShjwKA=",
                                                    fit: BoxFit.fill,
                                                  ),
                                                  errorWidget: (context, url, error) => Image.network(
                                                    "https://media.istockphoto.com/id/913241794/vector/green-store-flat-design-environmental-icon.jpg?s=612x612&w=0&k=20&c=aBl5y54IVOQU__JocerMWJHTEsa3PBR1eZyBlShjwKA=",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Shop Info
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                    child: Text(
                                                      shop.businessName.toString(),
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Center(
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(
                                                          color: Colors.green.withOpacity(0.3),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.location_on,
                                                            size: 14,
                                                            color: Colors.green.shade800,
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Flexible(
                                                            child: Text(
                                                              formattedDistance,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.green.shade800,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                childCount: business.length,
                              ),
                            ),
                          )
                    : const SliverToBoxAdapter(
                        child: Center(
                          child: Text("Loading..."),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
