import 'package:flutter/material.dart';

import '../utils/color_manager.dart';
import '../utils/text_manager.dart';

class SpecialPackageButtonComponent extends StatelessWidget {
  final String text;
  final String text2;
  final String? imagePath;
  final IconData? iconData;
  final double? width;
  final double? height;
  final double? scale;

  const SpecialPackageButtonComponent({
    super.key,
    this.scale,
    this.imagePath,
    required this.text,
    required this.text2,
    this.iconData,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40,
      width: width ?? 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorManager.home_button,
      ),
      child: Center( // Center the entire content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min, // Shrink to fit content
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (iconData != null)
                  Icon(
                    iconData,
                    size: 24, // Adjusted size for better alignment
                  ),
                if (imagePath != null) ...[
                  const SizedBox(width: 5), // Spacing between icon and text
                  Image.asset(
                    imagePath!,
                    scale: scale ?? 14,
                  ),
                ],
                const SizedBox(width: 8), // Spacing between image/icon and text
                Text(
                  text,
                  style: const TextStyle(fontSize: 24,fontFamily: 'UrduFont'),
                ),
              ],
            ),
             const SizedBox(height: 10,),
             Text(
              text2,
              style: const TextStyle(fontSize: 20,fontFamily: 'UrduFont',),textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
