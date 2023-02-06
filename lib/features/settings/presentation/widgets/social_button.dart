import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButton extends StatelessWidget {
  final String image;
  final Function()? onTap;
  const SocialButton({Key? key, required this.image, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20.r,
        backgroundImage: ExactAssetImage(image),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
