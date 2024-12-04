import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehr_remake/view/home/special_package_screen/special_package_screen.dart';
import '../../../components/loading_widget.dart';
import '../../../controller/special_package_controller.dart';
import '../../../utils/color_manager.dart';

class LocationSelectionScreen extends StatefulWidget {
  bool? isFromLogin;
  bool? isFromLogout = false;
  String? email;
  LocationSelectionScreen(
      {super.key, this.isFromLogin = false, this.email, this.isFromLogout});

  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String? selectedLocationId;
  Map<String, bool> selectedLocations = {};
  final SpecialPackageController controller =
      Get.put(SpecialPackageController());
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    print("Is From Login ==>${widget.isFromLogin}");
  }

  Future<void> _fetchLocations() async {
    setState(() {
      isLoading = true;
    });

    await controller.fetchLocations();
    if (controller.locations.isNotEmpty) {
      setState(() {
        for (var location in controller.locations) {
          selectedLocations[location.id] = false;
        }
        isLoading = false; // Set loading to false after fetching
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', 'Failed to fetch locations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade900,
                  Colors.green.shade500,
                  Colors.green.shade900,
                ],
              ),
            ),
            child: AppBar(
                title: const Text(
                  'Select Location',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                elevation: 4,
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                )),
          ),
        ),
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
        child: isLoading
            ? Center(child: loadingSpinkit(ColorManager.home_button, 90))
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: controller.locations.map((location) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                leading: Transform.scale(
                                  scale: 1.2,
                                  child: Radio<String>(
                                    value: location.id,
                                    groupValue: selectedLocationId,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedLocations
                                            .updateAll((key, value) => false);
                                        selectedLocations[location.id] = true;
                                        selectedLocationId = value;
                                      });
                                    },
                                    activeColor: ColorManager.home_button,
                                  ),
                                ),
                                title: Text(
                                  location.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        if (selectedLocationId == null) {
                          Get.snackbar('Error', 'Please select a location');
                        } else {
                          Get.to(() => SpecialPackageScreen(
                            email: widget.email,
                            isFromLogin: widget.isFromLogin,
                            selectedLocationId: selectedLocationId!,
                            isFromLogout: widget.isFromLogout,
                          ));
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.green.shade900,
                                Colors.green.shade500,
                                Colors.green.shade900,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade900.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
