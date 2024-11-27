import 'dart:math';
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

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Position? position;
  String? _currentLocationName;
  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey();
  late AnimationController _blinkAnimationController;
  bool _isLoading = true;
  bool showBlinking = true;
  String? identifier;

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
    getIdentifier();

    requestLocation();

    _initializeData();

    _blinkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    super.initState();

    if (showBlinking) {
      _blinkAnimationController.repeat(reverse: true);
    }

    context.read<BussinessController>().getBussinesss();
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
    _blinkAnimationController.dispose();
    super.dispose();
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
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  minHeight:
                      kToolbarHeight + AppMargin.m10 * 2, // Adjust as needed
                  maxHeight:
                      kToolbarHeight + AppMargin.m10 * 2, // Adjust as needed
                  child: Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppMargin.m10),
                    child: Row(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome ${userProvider.firstName} ${userProvider.lastName}",
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
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.width / 2,
                            ),
                            child: FlutterCarousel(
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                disableCenter: true,
                                viewportFraction:
                                    deviceSize.width > 800.0 ? 0.8 : 1.0,
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
                                      animation: _blinkAnimationController,
                                      builder: (context, child) {
                                        return Opacity(
                                          opacity: showBlinking
                                              ? _blinkAnimationController.value
                                              : 1.0,
                                          child: HomeButtonComponent(
                                            btnColor: Colors.redAccent
                                                .withOpacity(0.5),
                                            width: double.infinity,
                                            imagePath: AppIcons.specialIcon,
                                            iconColor: Colors.white,
                                            btnTextColor: Colors.white,
                                            name: "Special Package",
                                          ),
                                        );
                                      },
                                    )
                                  : const HomeButtonComponent(
                                      btnColor: Colors.redAccent,
                                      width: double.infinity,
                                      imagePath: AppIcons.specialIcon,
                                      iconColor: Colors.white,
                                      btnTextColor: Colors.white,
                                      name: "Special Package",
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppMargin.m17),
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
                        height: AppMargin.m18,
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppMargin.m10, vertical: AppMargin.m20),
                  child: Text(
                    "Shops Near You",
                    style: TextStyleManager.mediumTextStyle(fontSize: 16),
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

                                // Ensure shop.lat and shop.lon are not null
                                if (shop.lat == null || shop.lon == null) {
                                  return SizedBox();
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
                                              distance: formattedDistance, identifier: userProvider.id??"",),
                                        ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Fixed-size image container
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          ),
                                          child: Container(
                                            height:
                                                160, // Fixed height for the image
                                            width: double
                                                .infinity, // Image stretches to the card's width
                                            color: Colors.grey[
                                                200], // Placeholder background color
                                            child: CachedNetworkImage(
                                                fit: BoxFit
                                                    .cover, // Ensures consistent scaling
                                                imageUrl:
                                                    "${Constants.BASE_URL}/${shop.logo.toString()}",
                                                placeholder: (context, url) =>
                                                    Image.network(
                                                        "https://media.istockphoto.com/id/913241794/vector/green-store-flat-design-environmental-icon.jpg?s=612x612&w=0&k=20&c=aBl5y54IVOQU__JocerMWJHTEsa3PBR1eZyBlShjwKA=",
                                                        fit: BoxFit.fill),
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Image.network(
                                                      "https://media.istockphoto.com/id/913241794/vector/green-store-flat-design-environmental-icon.jpg?s=612x612&w=0&k=20&c=aBl5y54IVOQU__JocerMWJHTEsa3PBR1eZyBlShjwKA=",
                                                      fit: BoxFit.fill);
                                                }),
                                          ),
                                        ),
                                        // Fixed-size text container
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Shop Name with ellipsis
                                              SizedBox(
                                                height:
                                                    20, // Fixed height for shop name
                                                child: Text(
                                                  shop.businessName.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              // Distance with fixed height
                                              SizedBox(
                                                height:
                                                    20, // Fixed height for distance
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      formattedDistance,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
      );
    });
  }
}
