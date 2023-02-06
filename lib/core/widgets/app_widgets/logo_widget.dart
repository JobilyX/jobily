import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/images.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: logoImage,
      child: Center(
          child: Image.asset(
        logoImage,
        width: 200.w,
        height: 200.h,
      )),
    );
  }
}
