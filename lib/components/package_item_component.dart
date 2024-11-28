import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/color_manager.dart';

class PackageItem extends StatelessWidget {
  final String title;
  final String description;
  VoidCallback pressed;
  PackageItem({
    required this.title,
    required this.description,
    required this.pressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),  // Darker shadow color
            spreadRadius: 0,                       // Reduced spread
            blurRadius: 15,                        // Increased blur
            offset: const Offset(0, 0),            // Center shadow
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.14), // Lighter shadow
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),            // Bottom shadow
          ),
        ],
      ),
      child: Material(  // Changed from Card to Material for better shadow handling
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.white.withOpacity(0.6),
              ],
              stops: const [0.1, 0.9],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'UrduFont',
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'UrduFont',
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16.0),
                Center(
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
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      ),
                    ),
                    onPressed: pressed,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.black, size: 15),
                        SizedBox(width: 5),
                        Text('Activate Package',style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
