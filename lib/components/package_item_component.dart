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
    return Card(
      margin: const EdgeInsets.all(16.0),
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
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => ColorManager.gradient1)),
              onPressed: pressed,
              child: const Text('Activate Package',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}
