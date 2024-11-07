import 'package:flutter/material.dart';

import '../utils/app/constant.dart';
import '../utils/color_manager.dart';
import '../utils/size_config.dart';

class RadioButtonWidget<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String? label;
  final String text;
  final ValueChanged<T?> onChanged;

  const RadioButtonWidget({
    super.key,
    required this.value,
    required this.groupValue,
    this.label,
    required this.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      // splashColor: ColorManager.accent.withOpacity(0.5),
      borderRadius: BorderRadius.circular(100),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRadio(),
          buildHorizontalSpace(10),
          _buildText(),
        ],
      ),
    );
  }

  Widget _buildRadio() {
    final bool isSelected = value == groupValue;

    return CircleAvatar(
      radius: getProportionateScreenHeight(10),
      backgroundColor: ColorManager.grey,
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenHeight(3)),
        child: CircleAvatar(
          backgroundColor:
              isSelected ? ColorManager.primary : ColorManager.transparent,
        ),
      ),
    );
  }

  Widget _buildText() {
    // final bool isSelected = value == groupValue;
    return kTextBentonSansReg(
      text,
      fontSize: getProportionateScreenHeight(14),
      color: ColorManager.black.withOpacity(0.5),
    );
  }
}
