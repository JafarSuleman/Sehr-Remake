import 'package:flutter/material.dart';

import '../utils/app/constant.dart';
import '../utils/color_manager.dart';
import '../utils/size_config.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    Key? key,
    this.bgColor,
    this.dropdownColor,
    this.blurRadius,
    required this.lableText,
    required this.hintText,
    required this.selectedOption,
    required this.dropdownMenuItems,
    this.onChange,
  }) : super(key: key);

  final Color? bgColor;
  final Color? dropdownColor;
  final double? blurRadius;
  final String lableText;
  final String hintText;
  final String? selectedOption;
  final List<DropdownMenuItem<String>> dropdownMenuItems;
  final void Function(String?)? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(9),
      ),
      height: getProportionateScreenHeight(60),
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: bgColor ?? ColorManager.white,
        borderRadius: BorderRadius.circular(
          getProportionateScreenHeight(15),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withOpacity(0.1),
            blurRadius: blurRadius ?? getProportionateScreenHeight(15),
          ),
        ],
      ),
      child: Row(
        children: [
          buildHorizontalSpace(11),
          SizedBox(
            width: getProportionateScreenWidth(100),
            child: kTextBentonSansReg(
              lableText,
              color: ColorManager.textGrey.withOpacity(0.3),
            ),
          ),
          // buildHorizontalSpace(60),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(13),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: dropdownColor ?? ColorManager.lightGrey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      getProportionateScreenHeight(10),
                    ),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(23),
                    ),
                    child: DropdownButton(
                      // isExpanded: true,
                      hint: kTextBentonSansReg(hintText,
                          color: ColorManager.textGrey.withOpacity(0.3)),
                      value: selectedOption,
                      items: dropdownMenuItems,
                      onChanged: onChange,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// class DropDownWidget extends StatelessWidget {
//   const DropDownWidget({
//     super.key,
//     required this.hintText,
//     required this.selectedOption,
//     required this.dropdownMenuItems,
//     this.onChange,
//   });

//   final String hintText;
//   final String? selectedOption;
//   final List<DropdownMenuItem<String>> dropdownMenuItems;
//   final void Function(String?)? onChange;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: getProportionateScreenHeight(55),
//       decoration: BoxDecoration(
//         color: ColorManager.white,
//         borderRadius: BorderRadius.circular(
//           getProportionateScreenHeight(15),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: ColorManager.black.withOpacity(0.1),
//             blurRadius: getProportionateScreenHeight(15),
//           ),
//         ],
//       ),
//       child: DropdownButtonHideUnderline(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: getProportionateScreenWidth(28),
//           ),
//           child: DropdownButton<String>(
//             // itemHeight: getProportionateScreenHeight(55),
//             iconSize: getProportionateScreenHeight(24),
//             isExpanded: true, // Set to true for full-width dropdown
//             value: selectedOption,
//             hint: kTextBentonSansReg(
//               hintText,
//               color: ColorManager.black.withOpacity(0.3),
//             ),
//             items: dropdownMenuItems,
//             onChanged: onChange,
//           ),
//         ),
//       ),
//     );
//   }
// }
