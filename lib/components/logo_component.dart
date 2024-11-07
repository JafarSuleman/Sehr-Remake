import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/asset_manager.dart';
import '../utils/size_config.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppImages.logo,
          height: getProportionateScreenHeight(84),
          width: getProportionateScreenWidth(192),
        ),
        buildVerticleSpace(10),
        Text(
          'SOBER Economic &\nHousing Revolution',
          style: GoogleFonts.libreFranklin(
            fontSize: getProportionateScreenHeight(20),
            fontWeight: FontWeight.bold,
            letterSpacing: getProportionateScreenWidth(0.35),
            wordSpacing: getProportionateScreenWidth(3),
          ),
        ),
        // buildVerticleSpace(10),
        Text(
          'وَمِمَّا رَزَقْنَاهُمْ يُنْفِقُونَ',
          style: GoogleFonts.libreFranklin(
            fontSize: getProportionateScreenHeight(18),
            // fontWeight: FontWeight.bold,
            // wordSpacing: getProportionateScreenWidth(3.5),
          ),
        ),
      ],
    );
  }
}
