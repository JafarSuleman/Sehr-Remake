import 'package:flutter/material.dart';

import '../utils/color_manager.dart';
import '../utils/size_config.dart';

class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget({
    super.key,
    // required this.items,
    required this.leading,
    required this.title,
    required this.trailing,
  });
  // final List<ShopDataModel> items;
  final Widget leading;
  final Widget title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(100),
      width: SizeConfig.screenWidth,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: ColorManager.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            getProportionateScreenHeight(22),
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(18),
              horizontal: getProportionateScreenWidth(15),
            ),
            child: leading,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(18),
            ),
            child: SizedBox(
              width: getProportionateScreenWidth(140),
              child: title,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(15),
              horizontal: getProportionateScreenWidth(15),
            ),
            child: trailing,
          ),
        ],
      ),
    );
  }
}
