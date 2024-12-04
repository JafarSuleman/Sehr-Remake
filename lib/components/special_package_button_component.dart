import 'package:flutter/material.dart';

class SpecialPackageButtonComponent extends StatelessWidget {
  final double width;
  final double height;
  final String imagePath;
  final String text;
  final String text2;

  const SpecialPackageButtonComponent({
    Key? key,
    required this.width,
    required this.height,
    required this.imagePath,
    required this.text,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 50,
            height: 50,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'UrduFont',

                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text2,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'UrduFont',

                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
