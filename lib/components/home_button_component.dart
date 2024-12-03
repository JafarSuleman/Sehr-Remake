import 'package:flutter/material.dart';

import '../utils/color_manager.dart';
import '../utils/text_manager.dart';

class HomeButtonComponent extends StatelessWidget {
  final String name;
  final IconData? iconData;
  final String? imagePath;
  final double? width;
  final Color? btnColor;
  final Color? iconColor;
  final Color? btnTextColor;

  const HomeButtonComponent({
    super.key,
    this.btnColor,
    this.iconColor,
    this.btnTextColor,
    required this.name,
    this.iconData,
    this.width,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width ?? 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null)
              Icon(
                iconData,
                size: 20,
                color: iconColor ?? Colors.white,
              ),
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: 25,
                height: 25,
                fit: BoxFit.contain,
                color: iconColor ?? Colors.white,
              ),
            if (iconData != null || imagePath != null) const SizedBox(width: 5),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: btnTextColor ?? Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
