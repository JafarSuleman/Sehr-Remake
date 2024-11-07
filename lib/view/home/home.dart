import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:sehr_remake/view/home/special_package_screen/special_package_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/drawer_component.dart';
import '../../components/home_button_component.dart';
import '../../components/loading_widget.dart';
import '../../components/special_Package_Info_Dialog.dart';
import '../../controller/package_controller.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/routes/routes.dart';
import '../../utils/text_manager.dart';
import '../../utils/values_manager.dart';
import '../bussiness/home/registeration/bussiness_registeration_view.dart';
import 'alerts_screen.dart';
import 'selected_package.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with SingleTickerProviderStateMixin {
  Position? position;
  String? _currentLocationName;
  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey();
  late AnimationController _blinkAnimationController;
  bool _isLoading = true;
  bool showBlinking = true;

  Future<void> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      getCurrentLocation().then((value) {
        setState(() {
          position = value;
        });
        _getLocationName(value);
      });
    } else if (status.isDenied) {
      // Permission denied. You can handle this case by showing a dialog or message to the user.
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied. You can open the app settings to allow the user to enable location access.
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

  double calculateDistance1(BussinessModel shop, double userLat,
      double userLon) {
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
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
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

  List<BussinessModel> sortShopsByDistance(List<BussinessModel> allShops,
      Position userLocation) {
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
    // TODO: implement initState

    _initializeData();

    _blinkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..repeat(reverse: true);

    // context
    //     .read<UserController>()
    //     .getUserData(FirebaseAuth.instance.currentUser!.phoneNumber.toString(),context);

    super.initState();

    // Initialize the animation controller

    if (showBlinking) {
      _blinkAnimationController.repeat(reverse: true);
    }


    context.read<BussinessController>().getBussinesss();
    //context.read<PackageController>().fetchSpecialPackages();


    // context.read<PackageController>().addListener(_updateBlinkingState);
    // context.read<UserController>().addListener(_updateBlinkingState);
    //
    // // Initial update of blinking state
    // _updateBlinkingState();
    // Future.delayed(Duration.zero).then((value) async {
    //   await requestLocationPermission();
    //
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String identifier = prefs.getString('identifier') ?? '';
    //
    //
    //   await context.read<UserController>().getUserData(identifier,context);
    // });

    // context
    //     .read<UserController>()
    //     .getUserData(FirebaseAuth.instance.currentUser!.phoneNumber.toString(),context);
  }

  // void _updateBlinkingState() {
  //   final specialPackages = context.read<PackageController>().specialPackages;
  //   final userProvider = context.read<UserController>().userModel;
  //   List<String>? activatedSpecialPackageIds = userProvider.activatedSpecialPackageIds;
  //
  //   bool shouldBlink = false;
  //
  //   if (specialPackages.isNotEmpty) {
  //     for (var package in specialPackages) {
  //       if (activatedSpecialPackageIds == null || !activatedSpecialPackageIds.contains(package.id)) {
  //         // There is a special package that the user hasn't activated
  //         shouldBlink = true;
  //         break;
  //       }
  //     }
  //   }
  //
  //   setState(() {
  //     showBlinking = shouldBlink;
  //     if (showBlinking) {
  //       _blinkAnimationController.repeat(reverse: true);
  //     } else {
  //       _blinkAnimationController.stop();
  //     }
  //   });
  // }

  Future<void> _initializeData() async {
    // Ensure loading state at the beginning
    setState(() {
      _isLoading = true;
    });

    await requestLocationPermission();

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
    _blinkAnimationController.dispose();
    // Remove listeners to prevent memory leaks
    // context.read<PackageController>().removeListener(_updateBlinkingState);
    // context.read<UserController>().removeListener(_updateBlinkingState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return Scaffold(
        body: Center(child: loadingSpinkit(ColorManager.gradient1, 80)),
      );
    }
    return Consumer<UserController>(
        builder: (context, userController, child) {
          var userProvider = context
              .watch<UserController>()
              .userModel;

          print(userProvider.firstName);
          print("Special Package ==> ${userProvider.specialPackage}");

          if (userProvider.package == "653e1c4c9818104d6fc5797f" ||
              userProvider.package == "653e1c4c9818104d6fc57980" ||
              userProvider.package == "653e1c4c9818104d6fc57981" ||
              userProvider.package == "653e1c4c9818104d6fc57988" ||
              userProvider.package == "653e1e979818104d6fc5798b") {
            context
                .watch<BussinessController>()
                .checkForBussinessData(
                FirebaseAuth.instance.currentUser!.phoneNumber.toString())
                .then((value) {
              if (value == true) {
                return;
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(
                      builder: (context) => const AddBusinessDetailsView()));
            });
          }
          var business = context
              .watch<BussinessController>()
              .bussinessModel;
          var deviceSize = MediaQuery
              .of(context)
              .size;
          if (position != null) {
            business.sort((a, b) =>
                calculateDistance1(
                    a, position!.latitude, position!.longitude)
                    .compareTo(
                    calculateDistance1(
                        b, position!.latitude, position!.longitude)));
          }


          return Scaffold(
            key: _scafoldKey,
            drawer: DrawerComponent(
                name: "${userProvider.firstName} ${userProvider.lastName}",
                phone: userProvider.email != null ? userProvider.email
                    .toString() : userProvider.mobile.toString(),
                imgUrl: userProvider.avatar.toString()),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppMargin.m10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _scafoldKey.currentState!.openDrawer();
                            },
                            icon: Icon(
                              Icons.horizontal_split_sharp,
                              color: ColorManager.gradient1,
                              size: 25,
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome ${userProvider.firstName} ${userProvider
                                  .lastName}",
                              style: TextStyleManager.mediumTextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(
                              height: AppMargin.m6,
                            ),
                            Text(
                              _currentLocationName == null
                                  ? "Loading Location..."
                                  : _currentLocationName!,
                              style: TextStyleManager.lightTextStyle(
                                  fontSize: 11,
                                  textColor: ColorManager.textGrey),
                            )
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_active_outlined,
                              size: 35,
                              color: ColorManager.gradient2,
                            ))
                      ],
                    ),

                    const SizedBox(
                      height: AppMargin.m16,
                    ),
                    //Banner Start
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery
                                .of(context)
                                .size
                                .width / 2,
                          ),
                          child: FlutterCarousel(
                            options: CarouselOptions(
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              disableCenter: true,
                              viewportFraction: deviceSize.width > 800.0
                                  ? 0.8
                                  : 1.0,
                              height: deviceSize.height * 0.45,
                              enableInfiniteScroll: true,
                              slideIndicator: const CircularSlideIndicator(),
                            ),
                            items: [
                              Image.network(
                                  "${Constants.BASE_URL}/uploads/11.png"),
                              Image.network(
                                  "${Constants.BASE_URL}/uploads/22.png"),
                              Image.network(
                                  "${Constants.BASE_URL}/uploads/33.png")
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppMargin.m17),

                    //Banner End
                    GestureDetector(
                      onTap: () {
                        specialPackageInfoDialog(context,userProvider.specialPackage);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            userProvider.specialPackage == null || userProvider.specialPackage!.isEmpty ?
                            AnimatedBuilder(
                              animation: _blinkAnimationController,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: showBlinking
                                      ? _blinkAnimationController.value
                                      : 1.0,
                                  child: HomeButtonComponent(
                                    btnColor: Colors.redAccent.withOpacity(0.5),
                                    width: double.infinity,
                                    imagePath: AppIcons.specialIcon,
                                    iconColor: Colors.white,
                                    btnTextColor: Colors.white,
                                    name: "Special Package",
                                  ),
                                );
                              },
                            ) : const HomeButtonComponent(
                              btnColor: Colors.redAccent,
                              width: double.infinity,
                              imagePath: AppIcons.specialIcon,
                              iconColor: Colors.white,
                              btnTextColor: Colors.white,
                              name: "Special Package",
                            ),

                            // Positioned(
                            //     right: -25,
                            //     bottom: 0,
                            //     child: Image.asset('assets/images/offer-Gif.gif',scale: 7.5,))
                          ],
                        ),
                      ),),
                    const SizedBox(height: AppMargin.m17),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(AlertScreen());
                            //Get.toNamed(Routes.alertRoute);
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
                                  builder: (
                                      context) => const SelectedPackageScreen(),
                                ));
                          },
                          child: const HomeButtonComponent(
                              name: "Packages", iconData: Icons.local_offer),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: AppMargin.m18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(ReportScreen());
                            //Get.toNamed(Routes.reportRoute);
                          },
                          child: const HomeButtonComponent(
                              name: "Reports",
                              iconData: Icons.history_edu_rounded),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const ShopViewScreen());
                            //Get.toNamed(Routes.shopviewRoute);
                          },
                          child: const HomeButtonComponent(
                              name: "Shops", iconData: Icons.store),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: AppMargin.m20,
                    ),
                    Text(
                      "Shops Near You",
                      style: TextStyleManager.mediumTextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: AppMargin.m20,
                    ),
                    //changed bussiness near loc strat
                    position != null
                        ? business.length.bitLength == 0
                        ? const Text(
                      "No Shops Here !",
                      style: TextStyle(fontSize: 16),
                    )
                        : Expanded(
                      child: GridView.builder(
                          itemCount: business.length.bitLength,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 25,
                              crossAxisSpacing: 25,
                              mainAxisExtent: 200),
                          itemBuilder: (context, index) {
                            List<BussinessModel> nearByShops = business;

                            final distance = calculateDistance(
                              position!.latitude,
                              position!.longitude,
                              nearByShops[index].lat as double,
                              nearByShops[index].lon as double,
                            );
                            final formattedDistance = distance < 1
                                ? '${(distance * 1000).toStringAsFixed(
                                2)} meters away'
                                : '${distance.toStringAsFixed(2)} km away';
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShopDetailsView(
                                              model: nearByShops[index],
                                              distance: formattedDistance),
                                    ));
                              },
                              child: GridTile(
                                header: SizedBox(
                                  height: 150,
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                      "${Constants
                                          .BASE_URL}/${nearByShops[index].logo
                                          .toString()}",
                                      placeholder: (context, url) =>
                                          Image.network(
                                              "https://media.istockphoto.com/id/913241794/vector/green-store-flat-design-environmental-icon.jpg?s=612x612&w=0&k=20&c=aBl5y54IVOQU__JocerMWJHTEsa3PBR1eZyBlShjwKA=",
                                              fit: BoxFit.fill),
                                      errorWidget: (context, url, error) {
                                        return Image.network(
                                            "https://media.istockphoto.com/id/913241794/vector/green-store-flat-design-environmental-icon.jpg?s=612x612&w=0&k=20&c=aBl5y54IVOQU__JocerMWJHTEsa3PBR1eZyBlShjwKA=",
                                            fit: BoxFit.fill);
                                      }),
                                ),
                                child: const Text(""),
                                footer: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(nearByShops[index]
                                        .businessName
                                        .toString()),
                                    Text(formattedDistance)
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                        : const Center(
                      child: Text("Enable Location to get Shops"),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}