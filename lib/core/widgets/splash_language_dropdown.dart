import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/space.dart';
import '../../../../../core/constant/colors/colors.dart';
import '../../../../../core/constant/styles/styles.dart';
import '../../../../core/constant/size_config.dart';
import '../../../../core/widgets/side_padding.dart';

class BuildDropDown<T> extends StatelessWidget {
  final double? buttonHeight;
  final double? buttonWidth;
  final Color? textColor;
  final double? buttonRadius;
  final Color? dropdownColor;
  final Color? buildDropColor;
  final Widget? icon;
  final bool? isExpanded;
  final String hint;
  final String? image;
  final dynamic value;
  final dynamic onChange;
  final List<DropdownMenuItem<T>> items;

  const BuildDropDown({
    Key? key,
    this.dropdownColor,
    this.buildDropColor,
    this.textColor,
    this.icon,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonRadius,
    required this.isExpanded,
    required this.hint,
    required this.value,
    required this.onChange,
    required this.items,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: LimitedBox(
        maxHeight: buttonHeight ?? 70.h,
        maxWidth: buttonWidth ?? SizeConfig.screenWidth,
        child: Container(
          decoration: BoxDecoration(
              color: buildDropColor ?? white,
              border: Border.all(
                color: mainColor,
                width: .5.w,
              ),
              borderRadius: BorderRadius.circular(buttonRadius ?? 15.r)),
          child: SidePadding(
            sidePadding: 10,
            child: DropdownButton<T>(
              isExpanded: isExpanded!,
              elevation: 0,
              hint: Row(
                children: [
                  Space(
                    boxWidth: 10.w,
                  ),
                  image == null
                      ? const SizedBox()
                      : Image.asset(image!, height: 20.h, fit: BoxFit.contain),
                  Space(
                    boxWidth: 5.w,
                  ),
                  Text(
                    hint,
                    style: TextStyles.bodyText12
                        .copyWith(color: textColor ?? mainColor),
                  ),
                ],
              ),
              icon: icon ??
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: mainColor,
                    size: 30,
                  ),
              dropdownColor: dropdownColor ?? white,
              style: TextStyles.bodyText16.copyWith(color: mainColor),
              borderRadius: BorderRadius.circular(10.r),
              value: value,
              onChanged: onChange,
              items: items,
            ),
          ),
        ),
      ),
    );
  }
}
