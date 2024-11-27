import 'package:flutter/material.dart';
import '../utils/color_manager.dart';
import '../utils/size_config.dart';

class CustomListTileWidget extends StatelessWidget {

  const CustomListTileWidget({
    super.key,
    required this.leading,
    required this.title,
    required this.trailing,
  });

  final Widget leading;
  final Widget title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(10),
        horizontal: getProportionateScreenWidth(15),
      ),
      decoration: ShapeDecoration(
        color: ColorManager.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            getProportionateScreenHeight(22),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: getProportionateScreenWidth(60),
            height: getProportionateScreenHeight(60),
            child: leading,
          ),
          SizedBox(width: getProportionateScreenWidth(15)),
          Expanded(
            child: title,
          ),
          SizedBox(width: getProportionateScreenWidth(15)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: getProportionateScreenWidth(100),
                ),
                child: trailing,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
