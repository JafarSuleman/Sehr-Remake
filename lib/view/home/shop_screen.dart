import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import 'package:sehr_remake/view/home/shop/order_view.dart';
import '../../model/business_model.dart';
import '../../utils/app/constant.dart';
import '../../utils/color_manager.dart';
import 'shop/shop_detail_view.dart';

class ShopViewScreen extends StatefulWidget {
  const ShopViewScreen({super.key});

  @override
  State<ShopViewScreen> createState() => _ShopViewScreenState();
}

class _ShopViewScreenState extends State<ShopViewScreen> {
  final TextEditingController _searchController = TextEditingController();
  late GoogleMapController mapController;
  Position? currentLocation;
  String _currentLocationName = "";

  Future<void> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      getCurrentLocation().then((value) {
        setState(() {
          currentLocation = value;
        });
      });
    } else if (status.isDenied) {
      // Permission denied. You can handle this case by showing a dialog or message to the user.
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied. You can open the app settings to allow the user to enable location access.
      openAppSettings();
    }
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
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

  double radians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestLocationPermission();
  }

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

  LatLngBounds _calculateBounds() {
    var business = context.watch<BussinessController>().bussinessModel;
    LatLngBounds? bounds;
    for (var shop in business) {
      LatLng position = LatLng(shop.lat as double, shop.lon as double);

      bounds = LatLngBounds(southwest: position, northeast: position);
    }
    return bounds as LatLngBounds;
  }

  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            '${placemark.thoroughfare}, ${placemark.locality}, ${placemark.administrativeArea}';
        return address;
      }
    } catch (e) {
      print("Error fetching location address: $e");
    }
    return null;
  }

  void _goToMarker(LatLng position) {
    mapController.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    var business = context
        .watch<BussinessController>()
        .bussinessModel
        .where((element) => element.sehrCode != null)
        .toList();
    // Calculate the bounds based on marker positions.
    LatLngBounds bounds = _calculateBounds();

    // Create a Set of Marker objects to hold your shop markers.
    Set<Marker> markers = {};

    for (var shop in business) {
      // Create a LatLng object for the shop's position.
      LatLng position = LatLng(shop.lat as double, shop.lon as double);

      Marker marker = Marker(
        markerId: MarkerId(
            shop.id.toString()), // Use a unique identifier for each marker
        position: position,
        infoWindow: InfoWindow(title: shop.businessName, snippet: shop.about),
      );
      markers.add(marker);

      // Create a Marker object.

      // Add the marker to the set.
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back, color: Colors.black,
              ),
            ),
            const SizedBox(width: 30,),
            Icon(Icons.store, color: ColorManager.primary,size: 30,),
            const SizedBox(width: 8),
            Text(
              'All Shops',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: ColorManager.black,
              ),
            ),
          ],
        ),
      ),
      body: currentLocation == null
        ? Center(
            child: CircularProgressIndicator(
              color: ColorManager.primary,
            ),
          )
        : Container(
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: ColorManager.lightGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withOpacity(0.5)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: ColorManager.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search shops...',
                                  hintStyle: TextStyle(color: ColorManager.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Map View
                currentLocation != null
                  ? Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      margin: const EdgeInsets.all(6),
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
                        border: Border.all(
                          color: Colors.green.withOpacity(0.5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                currentLocation!.latitude,
                                currentLocation!.longitude,
                              ),
                              zoom: 15.0,
                            ),
                            markers: markers,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                          ),
                        ),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),

                // Shop List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _searchController.text.isEmpty
                        ? sortShopsByDistance(
                                business, currentLocation!)
                            .length
                        : sortShopsByDistance(
                                business, currentLocation!)
                                    .where((element) =>
                                        element.businessName!
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()) ||
                                        element.ownerName!
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                    .toList()
                                    .length,
                    itemBuilder: (context, index) {
                      List<BussinessModel> sortedBussiness =
                          _searchController.text.isEmpty
                              ? sortShopsByDistance(
                                  business, currentLocation!)
                              : sortShopsByDistance(
                                      business, currentLocation!)
                                          .where((element) =>
                                              element.businessName!
                                                  .toLowerCase()
                                                  .contains(_searchController
                                                      .text
                                                      .toLowerCase()) ||
                                              element.ownerName!
                                                  .toLowerCase()
                                                  .contains(_searchController
                                                      .text
                                                      .toLowerCase()))
                                          .toList();
                      final distance = calculateDistance(
                        currentLocation!.latitude,
                        currentLocation!.longitude,
                        sortedBussiness[index].lat as double,
                        sortedBussiness[index].lon as double,
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
                                        model: sortedBussiness[index],
                                        distance: formattedDistance, identifier: '',
                                       )));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.5),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ColorManager.primary.withOpacity(0.05),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: CachedNetworkImage(
                                      imageUrl: "${Constants.BASE_URL}/${sortedBussiness[index].logo.toString()}",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Image.asset(SEHR_SHOP_ICON, fit: BoxFit.fill),
                                      errorWidget: (context, url, error) => Image.asset(SEHR_SHOP_ICON, fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sortedBussiness[index].businessName.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ColorManager.black,
                                            overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          sortedBussiness[index].ownerName.toString(),
                                          style: TextStyle(
                                            color: ColorManager.black,
                                            fontSize: 14,
                                              overflow: TextOverflow.ellipsis

                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formattedDistance,
                                          style: TextStyle(
                                            color: ColorManager.primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _goToMarker(LatLng(
                                        sortedBussiness[index].lat as double,
                                        sortedBussiness[index].lon as double
                                    ));
                                  },
                                  child: Container(
                                    height: 40,
                                    width:  58,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green.shade900,
                                          Colors.green.shade500,
                                          Colors.green.shade900,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.25),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child:  Center(
                                      child: Text('Go to',
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
