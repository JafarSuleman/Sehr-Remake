import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/special_package_controller.dart';
import '../utils/color_manager.dart';

class SpecialPackageItem extends StatelessWidget {
  final String packageId;
  final String title;
  final String description;
  final String note;
  final String description2;
  final VoidCallback viewListPressed;
  final VoidCallback activatePressed;
  final String type;
  final String activateButtonText;

  SpecialPackageItem({
    Key? key,
    required this.packageId,
    required this.title,
    required this.description,
    required this.note,
    required this.description2,
    required this.activatePressed,
    required this.viewListPressed,
    required this.type,
    this.activateButtonText = "Activate", // Default text for the button
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SpecialPackageController>();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
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
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade900.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'UrduFont',
                    color: Colors.green.shade900,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                description,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UrduFont',
                  color: Colors.green.shade800,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  controller.showInfoDialog(context, title, description2, note);
                },
                child: Text(
                  'تفصیل دیکھیں',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'UrduFont',
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: viewListPressed,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff134250),
                              const Color(0xff12293c),
                              Colors.blue.shade800,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minWidth: 88, minHeight: 36),
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.list_alt, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'View List',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: activatePressed,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade900,
                              Colors.green.shade500,
                              Colors.green.shade900,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minWidth: 88, minHeight: 36),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              activateButtonText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
}
