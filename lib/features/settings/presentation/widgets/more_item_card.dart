import 'package:flutter/material.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/styles/styles.dart';

class MoreItemCard extends StatelessWidget {
  final String text;
  final String? image;
  final VoidCallback? tap;
  final Color? imagecolor;
  final Color? textColor;
  final double? imagewidth;
  const MoreItemCard({
    Key? key,
    this.image,
    this.tap,
    this.imagecolor,
    this.textColor,
    this.imagewidth,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: tap,
          leading: image == null
              ? null
              : SizedBox(
                  width: 30,
                  child: Image.asset(
                    image!,
                    height: imagewidth ?? 20,
                    color: imagecolor ?? mainColor,
                  ),
                ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Text(
              text,
              style:
                  TextStyles.bodyText12.copyWith(color: textColor ?? mainColor),
            ),
          ),
        ),
        Divider(color: Colors.grey[200], height: 2)
      ],
    );
  }
}
