import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/size_config.dart';

import '../../../../../core/constant/colors/colors.dart';
import '../../../../../core/shimmer/custom_shimmer.dart';

class AboutUsShimmer extends StatelessWidget {
  const AboutUsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
        child: ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
            left: 10 + index * 25, right: 10, top: 5, bottom: 5),
        child: Container(
          height: 20.h,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(25)),
        ),
      ),
    ));
  }
}
