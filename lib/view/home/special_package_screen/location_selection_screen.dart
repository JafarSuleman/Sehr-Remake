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
   LocationSelectionScreen({super.key,this.isFromLogin=false,this.email,this.isFromLogout});

  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String? selectedLocationId;
  Map<String, bool> selectedLocations = {};
  final SpecialPackageController controller = Get.put(SpecialPackageController());
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
      appBar: AppBar(
        title: const Text('Select Location'),
        centerTitle: true,
        backgroundColor: ColorManager.home_button,
      ),
      body: isLoading
          ?  Center(child: loadingSpinkit(ColorManager.home_button,90)) // Show loading indicator if fetching
          : Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                SingleChildScrollView(
                        child: Column(
                children: controller.locations.map((location) {
                  return ListTile(
                    leading: Checkbox(
                      value: selectedLocations[location.id] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedLocations.updateAll((key, value) => false);
                          selectedLocations[location.id] = value ?? false;
                          selectedLocationId = value == true ? location.id : null;
                        });
                      },
                    ),
                    title: Text(location.title),
                  );
                }).toList(),
                        ),
                      ),
                SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => ColorManager.home_button,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      print("Selected Location Id ==> $selectedLocationId");
                      if (selectedLocationId == null) {
                        Get.snackbar('Error', 'Please select a location');
                      } else {
                        // Navigate to SpecialPackageScreen with selectedLocationId
                        Get.to(() => SpecialPackageScreen(
                          email: widget.email,
                          isFromLogin: widget.isFromLogin, // Set according to your requirement
                          selectedLocationId: selectedLocationId!,
                          isFromLogout: widget.isFromLogout,
                        ));
                      }
                    },
                    child: const Text('Continue', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
