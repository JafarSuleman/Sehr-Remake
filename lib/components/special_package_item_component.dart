import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../controller/special_package_controller.dart';
import '../controller/user_controller.dart';
import '../controller/user_view_list_controller.dart';
import '../utils/color_manager.dart';
import '../view/home/special_package_screen/view_list_screen.dart';

class SpecialPackageItem extends StatelessWidget {
  final String packageId;
  final String title;
  final String description;
  final String note; // Nullable note
  final String description2;
  final VoidCallback viewListPressed;
  final VoidCallback activatePressed;
  final String type;

  SpecialPackageItem({
    Key? key,
    required this.packageId,
    required this.title,
    required this.description,
    required this.note,
    required this.description2,
    required this.activatePressed,
    required this.viewListPressed,
    required this.type
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tableController = Get.find<UserTableController>();
    final controller = Get.find<SpecialPackageController>();

    return Consumer<UserController>(
        builder: (context, userController, child) {
          var userProvider = context.watch<UserController>().userModel;
          bool isActivated = userProvider.specialPackage == packageId;
          bool? isAnyPackageActivated = userProvider.specialPackage != null;
          bool isLoading = userProvider.specialPackage == packageId;



          return Card(
            elevation: 1,
            margin: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE0FFE8), Colors.white],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'UrduFont',
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'UrduFont',
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        controller.showInfoDialog(context, title, description2, note);
                      },
                      child: const Text(
                        'تفصیل دیکھیں',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'UrduFont',
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.lightBlue,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith(
                                    (states) => ColorManager.lightBlue,
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                              ),
                            ),
                            onPressed: () {
                             tableController.fetchUsersBySpecialPackage(packageId, type);
                              Get.to(const ViewListScreen());
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.list_alt, color: Colors.black, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  'View List',
                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith(
                                    (states) => isActivated
                                    ? ColorManager.home_button // Original color for activated package
                                    : isAnyPackageActivated
                                    ? Colors.grey // Grey out other packages if one is activated
                                    : ColorManager.home_button,
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                              ),
                            ),
                            onPressed: isAnyPackageActivated || isActivated
                                ? null // Disable other buttons if one is activated
                                : activatePressed,
                            child: isActivated
                                ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: Colors.black, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  'Activated',
                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                ),
                              ],
                            )
                                : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: Colors.black, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  'Activate',
                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      );

  }
}
