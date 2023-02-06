import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobily/core/constant/icons.dart';

class LogoLottie extends StatelessWidget {
  final double logoHeight;
  final double logoWidth;
  const LogoLottie({
    Key? key,
    required this.logoHeight,
    required this.logoWidth,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      emailIcon,
      height: logoHeight.h,
      width: logoWidth.w,
      fit: BoxFit.fill,
    );
  }
}
